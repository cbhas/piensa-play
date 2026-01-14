// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/services/user_id_provider.dart';
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

  // Use Firebase Anonymous Auth UID instead of hardcoded ID
  String get userId => UserIdProvider.currentUserId;

  DashboardStats? _stats;
  UserProgress? _progress;
  String? _avatarId;
  String? _userName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      AppLogger.log('HOME: Iniciando carga de datos...');

      // Carga los tres datos EN SECUENCIA
      final profile = await _getUserProfile.execute();
      final stats = await _getDashboardStats.execute(userId);
      final progress = await _getUserProgress.execute(userId);

      AppLogger.log('HOME: Perfil recuperado: $profile');
      AppLogger.log('HOME: AvatarId: ${profile?.avatarId}');

      // Actualiza el estado con los datos cargados
      setState(() {
        _userName = profile?.name;
        _avatarId = profile?.avatarId;
        _stats = stats;
        _progress = progress;
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
      return 'assets/avatars/mascot.png';
    }
    final validIds = ['cocodrilo', 'pajaro', 'leopardo', 'tortuga'];
    if (!validIds.contains(avatarId)) {
      return 'assets/avatars/cocodrilo.png';
    }
    return 'assets/avatars/$avatarId.png';
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
                  avatarPath: _getAvatarPath(_avatarId),
                  userName: _userName,
                ).slideFromTop(duration: const Duration(milliseconds: 400)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MissionBanner(
                          onPressed: () {},
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
                                subtitle: '${_stats?.newGames ?? 0} nuevos',
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
                                    '${_stats?.pendingGlossary ?? 0} por completar',
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
                                    '${_stats?.achievements ?? 0} obtenidos',
                                icon: Icons.emoji_events,
                                color: AppTheme.accentYellow,
                                borderColor: AppTheme.accentYellow,
                                onTap: () {
                                  Navigator.pushNamed(context, '/achievements');
                                },
                              ).staggeredEntry(index: 2),
                              DashboardCard(
                                title: 'Misiones',
                                subtitle:
                                    '${_stats?.activeMissions ?? 0} activas',
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
                          progress: _progress?.generalProgress ?? 0.0,
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
            Navigator.pushReplacementNamed(context, '/glossary');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
          // index == 0 is already on home
        },
      ),
    );
  }
}
