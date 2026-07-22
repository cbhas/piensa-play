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
    final english = Localizations.localeOf(context).languageCode == 'en';
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.blueFill(dark),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.history,
                      color: AppTheme.blueText(dark),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    english ? 'Recent Activities' : 'Actividades Recientes',
                    style: Theme.of(context).textTheme.titleLarge,
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
        ),
      ),
    );
  }
}
