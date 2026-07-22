import 'package:flutter/material.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/flagship_content.dart';
import '../../data/flagship_progress_service.dart';
import '../../domain/flagship_mission.dart';
import '../piensa_ui.dart';
import 'facilitator_guide_page.dart';
import 'flagship_mission_page.dart';
import 'impact_assessment_page.dart';

class DigitalCityPage extends StatefulWidget {
  final bool demoMode;

  const DigitalCityPage({super.key, this.demoMode = false});

  @override
  State<DigitalCityPage> createState() => _DigitalCityPageState();
}

class _DigitalCityPageState extends State<DigitalCityPage> {
  final _progress = FlagshipProgressService();
  Set<String> _completed = {};
  LearningImpact _impact = const LearningImpact(
    decisions: 0,
    correctFirstTry: 0,
    missionsCompleted: 0,
  );
  bool _classroomMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final completed = await _progress.completedMissions();
    final impact = await _progress.impact();
    if (!mounted) return;
    setState(() {
      _completed = completed;
      _impact = impact;
    });
  }

  Future<void> _openMission(FlagshipMission mission, int index) async {
    final unlocked =
        index == 0 ||
        _completed.contains(FlagshipContent.missions[index - 1].id);
    if (!unlocked) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.strings.t('locked'))));
      return;
    }

    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FlagshipMissionPage(
          mission: mission,
          missionIndex: index,
          classroomMode: _classroomMode,
        ),
      ),
    );
    await _load();
  }

  Future<void> _openAssessment(bool isPost) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ImpactAssessmentPage(isPost: isPost)),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final trust = (_completed.length / FlagshipContent.missions.length).clamp(
      0.0,
      1.0,
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 235,
            foregroundColor: Colors.white,
            backgroundColor: AppTheme.primaryDark,
            actions: [
              IconButton(
                tooltip: strings.t('facilitator'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FacilitatorGuidePage(),
                  ),
                ),
                icon: const Icon(Icons.school_outlined),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 88, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.demoMode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentYellow,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'UNESCO 2026 · DEMO',
                          style: TextStyle(
                            color: AppTheme.tertiaryDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Text(
                      strings.t('cityTitle'),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.t('citySubtitle'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: trust,
                              minHeight: 10,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(
                                AppTheme.accentGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(trust * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Card(
                child: SwitchListTile.adaptive(
                  value: _classroomMode,
                  onChanged: (value) => setState(() => _classroomMode = value),
                  secondary: const Icon(Icons.groups_2_outlined),
                  title: Text(strings.t('classroom')),
                  subtitle: Text(strings.t('classroomBody')),
                ),
              ),
            ),
          ),
          if (_impact.baselineScore == null ||
              (_completed.length == FlagshipContent.missions.length &&
                  _impact.postScore == null))
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              sliver: SliverToBoxAdapter(
                child: _AssessmentCard(
                  isPost: _impact.baselineScore != null,
                  onTap: () => _openAssessment(_impact.baselineScore != null),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: FlagshipContent.missions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final mission = FlagshipContent.missions[index];
                final completed = _completed.contains(mission.id);
                final unlocked =
                    index == 0 ||
                    _completed.contains(FlagshipContent.missions[index - 1].id);
                return _MissionCityCard(
                  number: index + 1,
                  mission: mission,
                  completed: completed,
                  unlocked: unlocked,
                  onTap: () => _openMission(mission, index),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverToBoxAdapter(child: _ImpactCard(impact: _impact)),
          ),
        ],
      ),
    );
  }
}

class _MissionCityCard extends StatelessWidget {
  final int number;
  final FlagshipMission mission;
  final bool completed;
  final bool unlocked;
  final VoidCallback onTap;

  const _MissionCityCard({
    required this.number,
    required this.mission,
    required this.completed,
    required this.unlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final foreground = unlocked ? AppTheme.ink : AppTheme.muted;
    return Semantics(
      button: true,
      enabled: unlocked,
      label: strings.t(mission.titleKey),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: unlocked
                        ? mission.color
                        : Theme.of(
                            context,
                          ).disabledColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    unlocked ? mission.icon : Icons.lock_outline_rounded,
                    color: unlocked ? AppTheme.primaryDark : AppTheme.muted,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '0$number',
                            style: TextStyle(
                              color: mission.color.computeLuminance() > 0.7
                                  ? AppTheme.primaryDark
                                  : mission.color,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (completed)
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green.shade600,
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        strings.t(mission.titleKey),
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: foreground),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        unlocked
                            ? strings.t(mission.subtitleKey)
                            : strings.t('locked'),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: mission.skills
                            .map(
                              (skill) => PiensaSkillChip(
                                skill: skill,
                                color: unlocked
                                    ? AppTheme.primaryDark
                                    : AppTheme.muted,
                                compact: true,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final LearningImpact impact;
  const _ImpactCard({required this.impact});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final english = Localizations.localeOf(context).languageCode == 'en';
    final assessment = impact.baselineScore != null && impact.postScore != null
        ? (english
              ? 'Assessment: ${impact.baselineScore}/3 → ${impact.postScore}/3'
              : 'Evaluación: ${impact.baselineScore}/3 → ${impact.postScore}/3')
        : (english
              ? '${impact.decisions} decisions · ${(impact.firstTryRate * 100).round()}% first try'
              : '${impact.decisions} decisiones · ${(impact.firstTryRate * 100).round()}% al primer intento');
    return Card(
      color: AppTheme.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.insights_rounded,
              color: AppTheme.accentGreen,
              size: 34,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.t('impact'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assessment,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final bool isPost;
  final VoidCallback onTap;
  const _AssessmentCard({required this.isPost, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    return Card(
      color: AppTheme.accentBlue.withValues(alpha: 0.16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.accentBlue,
          child: Icon(Icons.query_stats_rounded, color: AppTheme.primaryDark),
        ),
        title: Text(
          isPost
              ? (english ? 'Measure what changed' : 'Mide lo que cambió')
              : (english
                    ? 'Set your starting point'
                    : 'Registra tu punto de partida'),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          english
              ? 'Three anonymous decisions, about one minute.'
              : 'Tres decisiones anónimas, cerca de un minuto.',
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
        onTap: onTap,
      ),
    );
  }
}
