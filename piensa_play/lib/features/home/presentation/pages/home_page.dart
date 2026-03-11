// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/services/user_id_provider.dart';
import '../../../../core/services/daily_question_service.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/services/audio_service.dart';
import '../../../daily_question/presentation/pages/daily_question_page.dart';
import '../../../missions/domain/entities/unified_question.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/usecases/get_dashboard_stats.dart';
import '../../domain/usecases/get_user_progress.dart';
import '../../../onboarding/domain/usecases/get_user_profile.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/mission_banner.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/progress_circle.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetDashboardStats _getDashboardStats = GetDashboardStats();
  final GetUserProgress _getUserProgress = GetUserProgress();
  final GetUserProfile _getUserProfile = GetUserProfile();
  final DailyQuestionService _dailyService = DailyQuestionService();

  // Use Firebase Anonymous Auth UID instead of hardcoded ID
  String get userId => UserIdProvider.currentUserId;

  DashboardStats? _stats;
  UserProgress? _progress;
  String? _avatarId;
  String? _avatarPath;
  String? _userName;
  bool _isLoading = true;

  // Daily Question state
  bool _dailyAnswered = false;
  int _dailyStreak = 0;
  UnifiedQuestion? _dailyQuestion;

  @override
  void initState() {
    super.initState();
    _loadFromCacheFirst();
  }

  Future<void> _loadFromCacheFirst() async {
    // Primero intenta cargar desde caché (instantáneo, sin loading)
    final cachedProfile = AppDataService.instance.userProfile;

    if (cachedProfile != null) {
      // Ya hay datos en caché - mostrar inmediatamente sin loading
      setState(() {
        _userName = cachedProfile.name;
        _avatarId = cachedProfile.avatarId;
        _dailyStreak = AppDataService.instance.dailyStreak;
        _isLoading = false;
      });

      // Cargar datos adicionales en background (sin bloquear UI)
      _loadDailyQuestionData();
    } else {
      // No hay caché - hacer carga completa con loading
      await _loadData();
    }
  }

  Future<void> _loadDailyQuestionData() async {
    try {
      final dailyAnswered = await _dailyService.hasAnsweredToday();
      final dailyQuestion = await _dailyService.getTodaysQuestion();

      if (mounted) {
        setState(() {
          _dailyAnswered = dailyAnswered;
          _dailyQuestion = dailyQuestion;
        });
      }
    } catch (e) {
      AppLogger.warning('HOME: Error loading daily question: $e');
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      AppLogger.log('HOME: Iniciando carga de datos...');

      // Carga los tres datos EN SECUENCIA
      final profile = await _getUserProfile.execute();
      final stats = await _getDashboardStats.execute(userId);
      final progress = await _getUserProgress.execute(userId);

      // Cargar estado de pregunta diaria
      final dailyAnswered = await _dailyService.hasAnsweredToday();
      final dailyStreak = await _dailyService.getStreak();
      final dailyQuestion = await _dailyService.getTodaysQuestion();

      AppLogger.log('HOME: Perfil recuperado: $profile');
      AppLogger.log('HOME: AvatarId: ${profile?.avatarId}');
      AppLogger.log(
        'HOME: Daily answered: $dailyAnswered, streak: $dailyStreak',
      );

      // Actualiza el estado con los datos cargados
      setState(() {
        _userName = profile?.name;
        _avatarId = profile?.avatarId;
        _stats = stats;
        _progress = progress;
        _dailyAnswered = dailyAnswered;
        _dailyStreak = dailyStreak;
        _dailyQuestion = dailyQuestion;
        _isLoading = false;
      });

      // Guarda en Firestore DESPUÉS de renderizar
      await _getDashboardStats.save(userId, stats);
      await _getUserProgress.save(userId, progress);

      AppLogger.success('HOME: Avatar cargado: $_avatarId');
      AppLogger.success('HOME: Datos guardados en Firestore');
    } catch (e) {
      setState(() => _isLoading = false);
      AppLogger.error('HOME: Error: $e');
    }
  }

  String _getAvatarPath(String? avatarId) {
    if (avatarId == null || avatarId.isEmpty) {
      return 'assets/avatars/cocodrilo.png';
    }
    final validIds = ['cocodrilo', 'jaguar', 'pajaro', 'tortuga'];
    if (!validIds.contains(avatarId)) {
      return 'assets/avatars/cocodrilo.png';
    }
    return 'assets/avatars/$avatarId.png';
  }

  String _getMissionsSubtitle() {
    final categories = AppDataService.instance.missionCategories;
    int totalMissions = 0;
    int completedMissions = 0;

    for (final category in categories) {
      totalMissions += category.missions.length;
      completedMissions += category.missions.where((m) => m.isCompleted).length;
    }

    if (completedMissions == totalMissions && totalMissions > 0) {
      return '¡Todas completas!';
    }
    return '$completedMissions de $totalMissions';
  }

  double _calculateMissionProgress() {
    final categories = AppDataService.instance.missionCategories;
    int totalMissions = 0;
    int completedMissions = 0;

    for (final category in categories) {
      totalMissions += category.missions.length;
      completedMissions += category.missions.where((m) => m.isCompleted).length;
    }

    if (totalMissions == 0) return 0.0;
    return completedMissions / totalMissions;
  }

  Future<void> _onDailyBannerTap() async {
    if (_dailyAnswered) {
      // Ya respondió, ir a logros
      Navigator.pushNamed(context, '/achievements');
    } else if (_dailyQuestion != null) {
      // Abrir pregunta diaria
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => DailyQuestionPage(question: _dailyQuestion!),
        ),
      );

      // Si respondió, recargar datos
      if (result == true) {
        _loadData();
      }
    }
  }

  Future<void> _onAvatarChanged(String avatarId, String assetPath) async {
    // Actualizar UI inmediatamente
    setState(() {
      _avatarId = avatarId;
      _avatarPath = assetPath;
    });

    // Guardar en Firebase
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data')
          .update({'avatarId': avatarId, 'avatarPath': assetPath});

      // Reproducir sonido de confirmación
      AudioService().playCorrect();

      AppLogger.success('HOME: Avatar changed to $avatarId');
    } catch (e) {
      AppLogger.error('HOME: Error saving avatar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DashboardHeader(
                  avatarPath: _avatarPath ?? _getAvatarPath(_avatarId),
                  userName: _userName,
                  currentAvatarId: _avatarId ?? 'cocodrilo',
                  onAvatarChanged: _onAvatarChanged,
                ).slideFromTop(duration: const Duration(milliseconds: 400)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MissionBanner(
                          isAvailable:
                              !_dailyAnswered && _dailyQuestion != null,
                          isCompleted: _dailyAnswered,
                          streak: _dailyStreak,
                          timeRemaining: _dailyAnswered
                              ? _dailyService.getTimeUntilNextQuestion()
                              : null,
                          onPressed: () => _onDailyBannerTap(),
                        ).fadeInSlide(delay: const Duration(milliseconds: 200)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: [
                              DashboardCard(
                                title: 'Aprende',
                                subtitle: 'Videos y tips',
                                icon: Icons.videogame_asset,
                                color: AppTheme.accentGreen,
                                borderColor: AppTheme.accentGreen,
                                onTap: () {
                                  Navigator.pushNamed(context, '/learn');
                                },
                              ).staggeredEntry(index: 0),
                              DashboardCard(
                                title: 'Glosario',
                                subtitle:
                                    '${AppDataService.instance.glossaryTerms.length} términos',
                                icon: Icons.book,
                                color: AppTheme.accentBlue,
                                borderColor: AppTheme.accentBlue,
                                onTap: () {
                                  Navigator.pushNamed(context, '/glossary');
                                },
                              ).staggeredEntry(index: 1),
                              DashboardCard(
                                title: 'Logros',
                                subtitle:
                                    'Nivel ${AppDataService.instance.achievement.currentLevel}',
                                icon: Icons.emoji_events,
                                color: AppTheme.accentYellow,
                                borderColor: AppTheme.accentYellow,
                                onTap: () {
                                  Navigator.pushNamed(context, '/achievements');
                                },
                              ).staggeredEntry(index: 2),
                              DashboardCard(
                                title: 'Misiones',
                                subtitle: _getMissionsSubtitle(),
                                icon: Icons.star,
                                color: AppTheme.accentPink,
                                borderColor: AppTheme.accentPink,
                                onTap: () {
                                  Navigator.pushNamed(context, '/missions');
                                },
                              ).staggeredEntry(index: 3),
                            ],
                          ),
                        ),
                        ProgressCircle(
                          progress: _calculateMissionProgress(),
                          monthlyProgress: _progress?.monthlyProgress ?? {},
                        ).scaleIn(delay: const Duration(milliseconds: 500)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/shop');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
          // index == 0 is already on home
        },
      ),
    );
  }
}
