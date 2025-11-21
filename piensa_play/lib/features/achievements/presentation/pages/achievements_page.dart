import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/badge.dart' as entities;
import '../../domain/entities/recent_activity.dart';
import '../../domain/usecases/get_achievements.dart';
import '../../domain/usecases/get_badges.dart';
import '../../domain/usecases/get_recent_activities.dart';
import '../widgets/progress_header.dart';
import '../widgets/overall_progress_card.dart';
import '../widgets/badge_grid.dart';
import '../widgets/recent_activities_list.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final GetAchievements _getAchievements = GetAchievements();
  final GetBadges _getBadges = GetBadges();
  final GetRecentActivities _getRecentActivities = GetRecentActivities();

  final String userId = 'user123';

  Achievement? _achievement;
  List<entities.Badge> _badges = [];
  List<RecentActivity> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      print('🔵 ACHIEVEMENTS: Iniciando carga de datos...');

      // Carga los datos en secuencia
      final achievement = await _getAchievements.execute(userId);
      final badges = await _getBadges.execute(userId);
      final activities = await _getRecentActivities.execute(userId);

      setState(() {
        _achievement = achievement;
        _badges = badges;
        _activities = activities;
        _isLoading = false;
      });

      // Guarda en Firestore después de renderizar
      await _getAchievements.save(userId, achievement);
      await _getBadges.save(userId, badges);
      await _getRecentActivities.save(userId, activities);

      print('🟢 ACHIEVEMENTS: Datos cargados y guardados');
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ ACHIEVEMENTS: Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const ProgressHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_achievement != null)
                          OverallProgressCard(
                            progress: _achievement!.generalProgress,
                            level: _achievement!.currentLevel,
                            totalXP: _achievement!.totalXP,
                            coins: _achievement!.coins,
                          ),
                        const SizedBox(height: 16),
                        BadgeGrid(badges: _badges),
                        const SizedBox(height: 16),
                        RecentActivitiesList(activities: _activities),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
