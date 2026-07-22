import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BadgeItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isUnlocked;

  const BadgeItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final lockedBg = dark ? Colors.white10 : Colors.grey.shade100;
    final lockedBorder = dark ? Colors.white24 : Colors.grey.shade300;
    final lockedIcon = dark ? Colors.white38 : Colors.grey.shade500;
    final lockedText = dark ? Colors.white54 : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.goldFill(dark) : lockedBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? AppTheme.goldText(dark) : lockedBorder,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? Theme.of(context).cardColor
                  : lockedIcon.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isUnlocked ? AppTheme.goldText(dark) : lockedIcon,
              size: 32,
            ),
          ),
          const SizedBox(height: 10),
          // Título
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppTheme.goldText(dark) : lockedText,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
