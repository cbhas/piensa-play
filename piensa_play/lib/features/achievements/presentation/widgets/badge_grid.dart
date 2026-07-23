import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../domain/entities/badge.dart' as entities;
import 'badge_item.dart';

class BadgeGrid extends StatelessWidget {
  final List<entities.Badge> badges;

  const BadgeGrid({super.key, required this.badges});

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'search':
        return Icons.search;
      case 'lock':
        return Icons.lock;
      case 'shield':
        return Icons.shield;
      case 'flag':
        return Icons.flag;
      case 'explore':
        return Icons.explore;
      default:
        return Icons.emoji_events;
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
                  color: AppTheme.goldFill(dark),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: AppTheme.goldText(dark),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                english ? 'Badges' : 'Insignias',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.0,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return BadgeItem(
                title: badge.title,
                icon: _getIconFromName(badge.iconName),
                isUnlocked: badge.isUnlocked,
              ).staggeredEntry(
                index: index,
                staggerDelay: const Duration(milliseconds: 60),
              );
            },
          ),
            ],
          ),
        ),
      ),
    );
  }
}
