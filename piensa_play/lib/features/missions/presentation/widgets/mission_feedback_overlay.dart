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
  final List<_ConfettiEmoji> _confetti = [];
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
    final emojis = ['🎉', '⭐', '✨', '🌟', '💫', '🎊'];
    for (int i = 0; i < 12; i++) {
      _confetti.add(
        _ConfettiEmoji(
          emoji: emojis[_random.nextInt(emojis.length)],
          left: _random.nextDouble() * 0.8 + 0.1, // 10% a 90%
          delay: i * 50,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.15),
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
                    // Emoji + Título en una fila
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isCorrect ? '🎉' : '😕',
                          style: const TextStyle(fontSize: 36),
                        ).animate().scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.isCorrect ? '¡Correcto!' : '¡Ups!',
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
                            child: Text(
                              widget.isCorrect ? '💡 Ver más' : '❓ Explica',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
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
                            child: const Text(
                              'CONTINUAR →',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                      child: Text(c.emoji, style: const TextStyle(fontSize: 28))
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

// Modelo simple para confetti de emoji
class _ConfettiEmoji {
  final String emoji;
  final double left;
  final int delay;

  _ConfettiEmoji({
    required this.emoji,
    required this.left,
    required this.delay,
  });
}
