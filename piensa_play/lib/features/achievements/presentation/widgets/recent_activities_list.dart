import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../domain/entities/recent_activity.dart';
import 'activity_item.dart';

class RecentActivitiesList extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivitiesList({super.key, required this.activities});

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'quiz':
        return Icons.quiz;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accentBlue.withOpacity(0.4),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentBlue, AppTheme.accentGreen],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.history, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Actividades Recientes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return ActivityItem(
              description: activity.description,
              xpReward: activity.xpReward,
              icon: _getIconFromName(activity.iconName),
            ).staggeredEntry(
              index: index,
              staggerDelay: const Duration(milliseconds: 60),
            );
          }),
        ],
      ),
    );
  }
}
