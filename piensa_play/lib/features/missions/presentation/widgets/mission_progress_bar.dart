import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Barra de progreso para misiones
/// Muestra progreso actual y número de pregunta
class MissionProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;

  const MissionProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
  });

  double get progress =>
      totalQuestions > 0 ? (currentQuestion) / totalQuestions : 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Contador de pregunta y score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Pregunta actual
              Text(
                'Pregunta ${currentQuestion + 1} de $totalQuestions',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
              // Score
              Row(
                children: [
                  if (correctAnswers > 0) ...[
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.accentGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$correctAnswers',
                      style: const TextStyle(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (incorrectAnswers > 0) ...[
                    const Icon(Icons.cancel, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$incorrectAnswers',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.accentGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
