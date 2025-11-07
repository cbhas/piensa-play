// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
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

  final String userId = 'user123';

  DashboardStats? _stats;
  UserProgress? _progress;
  String? _avatarId;
  int _currentNavIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      print('🔵 HOME: Iniciando carga de datos...');

      // Carga los tres datos EN SECUENCIA (no en paralelo) para evitar racing conditions
      final stats = await _getDashboardStats.execute(userId);
      final progress = await _getUserProgress.execute(userId);
      final profile = await _getUserProfile.execute();

      print('🟡 HOME: Perfil recuperado: $profile');
      print('🟡 HOME: AvatarId: ${profile?.avatarId}');

      setState(() {
        _stats = stats ?? const DashboardStats(
          newGames: 5,
          pendingGlossary: 3,
          achievements: 12,
          activeMissions: 2,
        );
        _progress = progress ?? UserProgress(
          generalProgress: 0.7,
          monthlyProgress: {'Mar': 0.5, 'Mié': 0.7},
        );
        _avatarId = profile?.avatarId ?? 'cocodrilo';
        _isLoading = false;
      });

      // Guarda en Firestore DESPUÉS de renderizar
      await _getDashboardStats.save(userId, _stats!);
      await _getUserProgress.save(userId, _progress!);

      print('🟢 HOME: Avatar cargado: $_avatarId');
      print('🟢 HOME: Datos guardados en Firestore');
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ HOME: Error: $e');
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          DashboardHeader(
            avatarPath: _getAvatarPath(_avatarId),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MissionBanner(onPressed: () {}),
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
                          title: 'Juegos Educativos',
                          subtitle: '${_stats?.newGames ?? 0} nuevos',
                          icon: Icons.videogame_asset,
                          color: const Color(0xFFA4D65E),
                          borderColor: const Color(0xFFA4D65E),
                          onTap: () {},
                        ),
                        DashboardCard(
                          title: 'Glosario',
                          subtitle: '${_stats?.pendingGlossary ?? 0} por completar',
                          icon: Icons.book,
                          color: const Color(0xFF6EC6FF),
                          borderColor: const Color(0xFF6EC6FF),
                          onTap: () {},
                        ),
                        DashboardCard(
                          title: 'Logros',
                          subtitle: '${_stats?.achievements ?? 0} obtenidos',
                          icon: Icons.emoji_events,
                          color: const Color(0xFFF4D03F),
                          borderColor: const Color(0xFFF4D03F),
                          onTap: () {},
                        ),
                        DashboardCard(
                          title: 'Misiones',
                          subtitle: '${_stats?.activeMissions ?? 0} activas',
                          icon: Icons.star,
                          color: const Color(0xFFE91E63),
                          borderColor: const Color(0xFFE91E63),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  ProgressCircle(
                    progress: _progress?.generalProgress ?? 0.0,
                    monthlyProgress: _progress?.monthlyProgress ?? {},
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}
