import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/services/app_data_service.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/badge.dart' as entities;
import '../widgets/progress_header.dart';
import '../widgets/overall_progress_card.dart';
import '../widgets/badge_grid.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  Achievement? _achievement;
  List<entities.Badge> _badges = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFromCache();
  }

  void _loadFromCache() {
    // Load from AppDataService cache (data already loaded during splash)
    setState(() {
      _achievement = AppDataService.instance.achievement;
      _badges = AppDataService.instance.badges;
    });
    print(
      '🔵 ACHIEVEMENTS: Loaded from cache - Level ${_achievement?.currentLevel}, ${_badges.length} badges',
    );
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      print('🔄 ACHIEVEMENTS: Refreshing data...');
      await AppDataService.instance.refreshAchievements();
      setState(() {
        _achievement = AppDataService.instance.achievement;
        _badges = AppDataService.instance.badges;
        _isLoading = false;
      });
      print('🟢 ACHIEVEMENTS: Data refreshed');
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ ACHIEVEMENTS: Error refreshing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          const ProgressHeader().slideFromTop(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.primaryDark,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (_achievement != null)
                            OverallProgressCard(
                              achievement: _achievement!,
                            ).fadeInSlide(
                              delay: const Duration(milliseconds: 200),
                            ),
                          const SizedBox(height: 16),
                          BadgeGrid(badges: _badges).fadeInSlide(
                            delay: const Duration(milliseconds: 300),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
