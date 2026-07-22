import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import 'base_question_widget.dart';

/// Widget Selección de Palabras - Diseño MINIMALISTA para niños
class WordSelectionWidget extends BaseQuestionWidget {
  final Set<String> selectedWords;
  final VoidCallback? onVerify;

  const WordSelectionWidget({
    super.key,
    required super.question,
    required super.onAnswer,
    super.isAnswered,
    this.selectedWords = const {},
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final words = question.options.map((o) => o.text).toList();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Emoji grande
                  const Text(
                    '🎯',
                    style: TextStyle(fontSize: 48),
                  ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 16),

                  // Título
                  Text(
                    question.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Instrucción simple
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '👆 Toca las palabras',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Grid de palabras (chips grandes y coloridos)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: words.asMap().entries.map((entry) {
                      final index = entry.key;
                      final word = entry.value;
                      final option = question.options[index];
                      final isSelected = selectedWords.contains(word);

                      return _buildWordChip(
                        word: word,
                        isSelected: isSelected,
                        isCorrect: option.isCorrect,
                        index: index,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onAnswer(option.isCorrect, option.id);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Contador simple
                  if (!isAnswered && selectedWords.isNotEmpty)
                    Text(
                      '${selectedWords.length} seleccionadas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Botón verificar
          if (!isAnswered) _buildVerifyButton(),
        ],
      ),
    );
  }

  Widget _buildWordChip({
    required String word,
    required bool isSelected,
    required bool isCorrect,
    required int index,
    required VoidCallback onTap,
  }) {
    // Colores vibrantes
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = AppTheme.primaryDark;

    if (isAnswered) {
      if (isCorrect) {
        bgColor = const Color(0xFF4CAF50);
        borderColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
      } else if (isSelected) {
        bgColor = const Color(0xFFE53935);
        borderColor = const Color(0xFFE53935);
        textColor = Colors.white;
      }
    } else if (isSelected) {
      bgColor = const Color(0xFF2196F3);
      borderColor = const Color(0xFF2196F3);
      textColor = Colors.white;
    }

    return GestureDetector(
          onTap: isAnswered ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: borderColor, width: 3),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: (40 * index).ms)
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildVerifyButton() {
    final hasSelection = selectedWords.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: hasSelection
                ? () {
                    HapticFeedback.mediumImpact();
                    onVerify?.call();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasSelection
                  ? const Color(0xFF4CAF50)
                  : Colors.grey.shade300,
              foregroundColor: Colors.white,
              elevation: hasSelection ? 4 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              hasSelection ? '¡VERIFICAR! ✓' : 'Selecciona palabras',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
