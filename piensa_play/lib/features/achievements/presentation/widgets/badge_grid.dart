import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accentYellow.withOpacity(0.4),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentYellow.withOpacity(0.15),
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
                    colors: [AppTheme.accentYellow, AppTheme.accentGreen],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Insignias',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
