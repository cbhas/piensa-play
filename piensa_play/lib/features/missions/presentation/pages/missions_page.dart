import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/app_data_service.dart';
import '../../domain/entities/mission_category.dart';
import '../widgets/missions_header.dart';
import '../widgets/mission_category_card.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  List<MissionCategory> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFromCache();
  }

  void _loadFromCache() {
    // Load from AppDataService cache (data already loaded during splash)
    setState(() {
      _categories = AppDataService.instance.missionCategories;
    });
    AppLogger.log(
      'MISSIONS: Loaded ${_categories.length} categories from cache',
    );
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      AppLogger.refresh('MISSIONS: Refreshing data...');
      await AppDataService.instance.refreshMissions();
      setState(() {
        _categories = AppDataService.instance.missionCategories;
        _isLoading = false;
      });
      AppLogger.success('MISSIONS: Data refreshed');
    } catch (e) {
      setState(() => _isLoading = false);
      AppLogger.error('MISSIONS: Error refreshing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Column(
        children: [
          const MissionsHeader(),
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
                          const SizedBox(height: 20),
                          ..._categories.map((category) {
                            return MissionCategoryCard(category: category);
                          }),
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
