import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/badge.dart' as entities;

/// Diálogo animado que aparece cuando se desbloquea un badge
class BadgeUnlockDialog extends StatelessWidget {
  final entities.Badge badge;
  final VoidCallback? onClose;

  const BadgeUnlockDialog({super.key, required this.badge, this.onClose});

  /// Muestra el diálogo con animación
  static Future<void> show(BuildContext context, entities.Badge badge) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BadgeUnlockDialog(
        badge: badge,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Muestra múltiples badges uno tras otro
  static Future<void> showMultiple(
    BuildContext context,
    List<entities.Badge> badges,
  ) async {
    for (final badge in badges) {
      if (!context.mounted) return;
      await show(context, badge);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

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
      case 'star':
        return Icons.star;
      case 'check':
        return Icons.check_circle;
      case 'trophy':
        return Icons.emoji_events;
      default:
        return Icons.workspace_premium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.accentYellow.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentYellow.withValues(alpha: 0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            const Text(
                  '🎉 ¡Nuevo Logro!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  curve: Curves.elasticOut,
                  duration: 600.ms,
                ),

            const SizedBox(height: 24),

            // Icono del badge con animación
            Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentYellow,
                        AppTheme.accentYellow.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentYellow.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconFromName(badge.iconName),
                    size: 60,
                    color: Colors.white,
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .scale(
                  delay: 200.ms,
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 800.ms,
                )
                .shimmer(
                  delay: 1000.ms,
                  duration: 1500.ms,
                  color: Colors.white.withValues(alpha: 0.3),
                ),

            const SizedBox(height: 24),

            // Nombre del badge
            Text(
                  badge.title.replaceAll('\n', ' '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 400.ms)
                .slideY(delay: 400.ms, begin: 0.3, end: 0),

            if (badge.description != null) ...[
              const SizedBox(height: 8),
              Text(
                badge.description!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            ],

            const SizedBox(height: 32),

            // Botón de cerrar
            ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    '¡Genial!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 400.ms)
                .scale(delay: 600.ms, begin: const Offset(0.8, 0.8)),
          ],
        ),
      ),
    );
  }
}
