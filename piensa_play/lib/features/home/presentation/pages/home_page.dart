import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/services/daily_question_service.dart';
import '../../../../core/services/user_id_provider.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../daily_question/presentation/pages/daily_question_page.dart';
import '../../../flagship/data/flagship_content.dart';
import '../../../flagship/data/flagship_progress_service.dart';
import '../../../missions/domain/entities/unified_question.dart';
import '../../../onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/usecases/get_user_progress.dart';
import '../widgets/progress_circle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _daily = DailyQuestionService();
  final _flagshipProgress = FlagshipProgressService();
  final _profiles = OnboardingRepositoryImpl();
  final _getUserProgress = GetUserProgress();

  UserProfile? _profile;
  UnifiedQuestion? _dailyQuestion;
  bool _dailyAnswered = false;
  int _dailyStreak = 0;
  Set<String> _completed = {};
  UserProgress? _userProgress;
  bool _loading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _load();
    }
  }

  Future<void> _load() async {
    final cached = AppDataService.instance.userProfile;
    final english = Localizations.localeOf(context).languageCode == 'en';
    final results = await Future.wait<dynamic>([
      cached == null ? _profiles.getUserProfile() : Future.value(cached),
      _daily.hasAnsweredToday(),
      _daily.getStreak(),
      _daily.getTodaysQuestion(english: english),
      _flagshipProgress.completedMissions(),
      _getUserProgress.execute(UserIdProvider.currentUserId),
    ]);
    if (!mounted) return;
    setState(() {
      _profile = results[0] as UserProfile?;
      _dailyAnswered = results[1] as bool;
      _dailyStreak = results[2] as int;
      _dailyQuestion = results[3] as UnifiedQuestion?;
      _completed = results[4] as Set<String>;
      _userProgress = results[5] as UserProgress?;
      _loading = false;
    });
  }

  String _avatarPath(String? id) {
    const valid = {'cocodrilo', 'jaguar', 'pajaro', 'tortuga'};
    return 'assets/avatars/${valid.contains(id) ? id : 'cocodrilo'}.png';
  }

  Future<void> _chooseAvatar() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.strings.t('avatarLabel'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: ['cocodrilo', 'jaguar', 'pajaro', 'tortuga']
                    .map(
                      (id) => InkWell(
                        onTap: () => Navigator.pop(context, id),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          width: 74,
                          height: 74,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: _profile?.avatarId == id
                                  ? AppTheme.primaryDark
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(_avatarPath(id)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected == null || _profile == null) return;
    final updated = _profile!.copyWith(avatarId: selected);
    await _profiles.saveUserProfile(updated);
    AppDataService.instance.updateUserProfile(updated);
    if (mounted) setState(() => _profile = updated);
  }

  Future<void> _openDaily() async {
    if (_dailyAnswered || _dailyQuestion == null) {
      Navigator.pushNamed(context, AppRoutes.achievements);
      return;
    }
    final answered = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DailyQuestionPage(question: _dailyQuestion!),
      ),
    );
    if (answered == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final achievement = AppDataService.instance.achievement;
    final cityProgress = (_completed.length / FlagshipContent.missions.length)
        .clamp(0.0, 1.0);

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _HomeHeader(
                      name: _profile?.name.isNotEmpty == true
                          ? _profile!.name
                          : strings.t('explorer'),
                      avatarPath: _avatarPath(_profile?.avatarId),
                      level: achievement.currentLevel,
                      coins: achievement.coins,
                      onAvatarTap: _chooseAvatar,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          strings.t('homeQuestion'),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ).fadeInSlide(),
                        const SizedBox(height: 18),
                        _CityHeroCard(
                          progress: cityProgress,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.missions,
                            );
                            await _load();
                          },
                        ).fadeInSlide(delay: 60.ms),
                        const SizedBox(height: 16),
                        _ClassicMissionsCard(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.legacyMissions,
                          ),
                        ).fadeInSlide(delay: 90.ms),
                        const SizedBox(height: 16),
                        _PiensaMethodCard().fadeInSlide(delay: 120.ms),
                        const SizedBox(height: 16),
                        _DailyCard(
                          answered: _dailyAnswered,
                          streak: _dailyStreak,
                          onTap: _openDaily,
                        ).fadeInSlide(delay: 180.ms),
                        const SizedBox(height: 22),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.28,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _QuickCard(
                              title: strings.t('learn'),
                              icon: Icons.play_lesson_outlined,
                              fill: AppTheme.blueFill(dark),
                              iconColor: AppTheme.blueText(dark),
                              onTap: () =>
                                  Navigator.pushNamed(context, AppRoutes.learn),
                            ),
                            _QuickCard(
                              title: strings.t('glossary'),
                              icon: Icons.menu_book_outlined,
                              fill: AppTheme.greenFill(dark),
                              iconColor: AppTheme.greenText(dark),
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.glossary,
                              ),
                            ),
                            _QuickCard(
                              title: strings.t('achievements'),
                              icon: Icons.emoji_events_outlined,
                              fill: AppTheme.goldFill(dark),
                              iconColor: AppTheme.goldText(dark),
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.achievements,
                              ),
                            ),
                            _QuickCard(
                              title: strings.t('shop'),
                              icon: Icons.storefront_rounded,
                              fill: AppTheme.coralFill(dark),
                              iconColor: AppTheme.coralText(dark),
                              onTap: () =>
                                  Navigator.pushNamed(context, AppRoutes.shop),
                            ),
                          ].animate(interval: 60.ms).fadeIn(duration: 300.ms).scale(
                            begin: const Offset(0.92, 0.92),
                            curve: Curves.easeOutBack,
                          ),
                        ),
                        if (_userProgress != null)
                          ProgressCircle(
                            progress: _userProgress!.generalProgress,
                            monthlyProgress: _userProgress!.monthlyProgress,
                          ).fadeInSlide(delay: 240.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: strings.t('appName'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_city_outlined),
            label: strings.t('missions'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.tune_rounded),
            label: strings.t('settings'),
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 1) Navigator.pushNamed(context, AppRoutes.missions);
          if (index == 2) Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String name;
  final String avatarPath;
  final int level;
  final int coins;
  final VoidCallback onAvatarTap;

  const _HomeHeader({
    required this.name,
    required this.avatarPath,
    required this.level,
    required this.coins,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 18,
        20,
        22,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: context.strings.t('changeAvatar'),
            child: InkWell(
              onTap: onAvatarTap,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Image.asset(avatarPath),
              ),
            ),
          ).scaleIn(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.t('hello', {'name': name}),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppTheme.accentYellow,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.strings.t('levelCoins', {
                        'level': '$level',
                        'coins': '$coins',
                      }),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ).fadeInSlide(delay: 80.ms),
          IconButton(
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
    );
  }
}

class _CityHeroCard extends StatelessWidget {
  final double progress;
  final VoidCallback onTap;
  const _CityHeroCard({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.secondaryDark, AppTheme.primaryDark],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.t('cityTitle'),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      strings.t('citySubtitle'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(
                          AppTheme.accentGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${(progress * 100).round()}% · ${strings.t('enterCity')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.location_city_rounded,
                  color: AppTheme.primaryDark,
                  size: 38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassicMissionsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ClassicMissionsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.greenFill(dark),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  Icons.explore_rounded,
                  color: AppTheme.greenText(dark),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.t('classicMissions'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.t('classicMissionsSubtitle'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PiensaMethodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.greenFill(dark),
              child: Icon(
                Icons.psychology_alt_rounded,
                color: AppTheme.greenText(dark),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.t('methodTitle'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(context.strings.t('methodBody')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  final bool answered;
  final int streak;
  final VoidCallback onTap;
  const _DailyCard({
    required this.answered,
    required this.streak,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.goldFill(dark),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(
            answered ? Icons.check_circle_rounded : Icons.bolt_rounded,
            color: AppTheme.goldText(dark),
          ),
        ),
        title: Text(
          context.strings.t('dailyChallenge'),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(context.strings.t('dailyReady')),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.orange,
            ),
            Text(
              '$streak',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color fill;
  final Color iconColor;
  final VoidCallback onTap;
  const _QuickCard({
    required this.title,
    required this.icon,
    required this.fill,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(icon, color: iconColor),
              ),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
