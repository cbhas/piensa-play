import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

/// Panel inferior de feedback estilo Duolingo (corto)
/// Con confetti de emojis cuando es correcto
class MissionFeedbackOverlay extends StatefulWidget {
  final bool isCorrect;
  final String explanation;
  final VoidCallback onContinue;
  final VoidCallback? onExplain;

  const MissionFeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.explanation,
    required this.onContinue,
    this.onExplain,
  });

  @override
  State<MissionFeedbackOverlay> createState() => _MissionFeedbackOverlayState();
}

class _MissionFeedbackOverlayState extends State<MissionFeedbackOverlay> {
  final List<_ConfettiIcon> _confetti = [];
  final Random _random = Random();
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();

    if (widget.isCorrect) {
      // Generar confetti después de que aparezca el popup
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _generateConfetti();
          setState(() => _showConfetti = true);
        }
      });
    }
  }

  void _generateConfetti() {
    const icons = [
      Icons.celebration_rounded,
      Icons.star_rounded,
      Icons.auto_awesome_rounded,
    ];
    const colors = [
      AppTheme.accentYellowAlt,
      AppTheme.accentPink,
      AppTheme.accentGreen,
      AppTheme.accentBlue,
    ];
    for (int i = 0; i < 12; i++) {
      _confetti.add(
        _ConfettiIcon(
          icon: icons[_random.nextInt(icons.length)],
          color: colors[_random.nextInt(colors.length)],
          left: _random.nextDouble() * 0.8 + 0.1, // 10% a 90%
          delay: i * 50,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    final accentColor = widget.isCorrect
        ? AppTheme.accentGreen
        : const Color(0xFFE53935);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Panel de feedback
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícono + Título en una fila
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.isCorrect
                              ? Icons.celebration_rounded
                              : Icons.sentiment_dissatisfied_rounded,
                          size: 36,
                          color: accentColor,
                        ).animate().scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.isCorrect
                              ? (english ? 'Correct!' : '¡Correcto!')
                              : (english ? 'Oops!' : '¡Ups!'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Dos botones
                    Row(
                      children: [
                        // Botón secundario (ver explicación)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              widget.onExplain?.call();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: accentColor,
                              side: BorderSide(color: accentColor, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.isCorrect
                                      ? Icons.lightbulb_rounded
                                      : Icons.help_outline_rounded,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.isCorrect
                                      ? (english ? 'See more' : 'Ver más')
                                      : (english ? 'Explain' : 'Explica'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Botón principal (continuar)
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              widget.onContinue();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  english ? 'CONTINUE' : 'CONTINUAR',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ).animate().slideY(
            begin: 1,
            end: 0,
            duration: 300.ms,
            curve: Curves.easeOutBack,
          ),

          // Confetti de emojis (aparece DESPUÉS del popup)
          if (_showConfetti)
            Positioned(
              left: 0,
              right: 0,
              bottom: 150, // Encima del popup
              height: 200,
              child: IgnorePointer(
                child: Stack(
                  children: _confetti.map((c) {
                    return Positioned(
                      left: MediaQuery.of(context).size.width * c.left - 20,
                      top: 0,
                      child: Icon(c.icon, size: 28, color: c.color)
                          .animate(delay: c.delay.ms)
                          .fadeIn(duration: 200.ms)
                          .slideY(
                            begin: -1,
                            end: 2,
                            duration: 800.ms,
                            curve: Curves.easeIn,
                          )
                          .fadeOut(delay: 600.ms, duration: 200.ms),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Modelo simple para confetti de íconos
class _ConfettiIcon {
  final IconData icon;
  final Color color;
  final double left;
  final int delay;

  _ConfettiIcon({
    required this.icon,
    required this.color,
    required this.left,
    required this.delay,
  });
}
