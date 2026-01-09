import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/services/user_id_provider.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/badge.dart' as entities;
import '../../domain/usecases/get_achievements.dart';
import '../../domain/usecases/get_badges.dart';
import '../widgets/progress_header.dart';
import '../widgets/overall_progress_card.dart';
import '../widgets/badge_grid.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final GetAchievements _getAchievements = GetAchievements();
  final GetBadges _getBadges = GetBadges();

  String get userId => UserIdProvider.currentUserId;

  Achievement? _achievement;
  List<entities.Badge> _badges = [];
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

      final achievement = await _getAchievements.execute(userId);
      final badges = await _getBadges.execute(userId);

      setState(() {
        _achievement = achievement;
        _badges = badges;
        _isLoading = false;
      });

      await _getAchievements.save(userId, achievement);
      await _getBadges.save(userId, badges);

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
                const ProgressHeader().slideFromTop(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_achievement != null)
                          OverallProgressCard(
                            achievement: _achievement!,
                          ).fadeInSlide(
                            delay: const Duration(milliseconds: 200),
                          ),
                        const SizedBox(height: 16),
                        BadgeGrid(
                          badges: _badges,
                        ).fadeInSlide(delay: const Duration(milliseconds: 300)),
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
