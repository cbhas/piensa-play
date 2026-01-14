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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.accentGreen, AppTheme.accentBlue],
              )
            : null,
        color: isUnlocked ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? AppTheme.accentYellow : Colors.grey.shade300,
          width: 2.5,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: AppTheme.accentGreen.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isUnlocked ? AppTheme.primaryDark : Colors.grey.shade500,
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
                color: isUnlocked ? Colors.white : Colors.grey.shade600,
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
