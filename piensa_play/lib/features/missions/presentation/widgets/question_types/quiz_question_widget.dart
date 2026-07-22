import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/unified_question.dart';
import 'base_question_widget.dart';

/// Widget para preguntas Quiz - Diseño MINIMALISTA para niños
class QuizQuestionWidget extends BaseQuestionWidget {
  final Set<String> selectedOptionIds;
  final VoidCallback? onVerify;

  const QuizQuestionWidget({
    super.key,
    required super.question,
    required super.onAnswer,
    super.isAnswered,
    this.selectedOptionIds = const {},
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
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
                  // Emoji grande de la misión
                  Text(
                    _getQuestionEmoji(),
                    style: const TextStyle(fontSize: 48),
                  ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 16),

                  // Pregunta principal (corta y directa)
                  Text(
                    question.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                      height: 1.3,
                    ),
                  ),

                  // Contenido resumido (si existe)
                  if (question.content != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _shortenText(question.content!, 200),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Opciones simples y grandes
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = selectedOptionIds.contains(option.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildOption(option, isSelected, index),
                    );
                  }),
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

  String _getQuestionEmoji() {
    if (question.content?.toLowerCase().contains('noticia') ?? false) {
      return '📰';
    }
    if (question.content?.toLowerCase().contains('vacuna') ?? false) {
      return '💉';
    }
    if (question.content?.toLowerCase().contains('agua') ?? false) {
      return '💧';
    }
    return '🤔';
  }

  String _shortenText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Widget _buildOption(AnswerOption option, bool isSelected, int index) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = AppTheme.primaryDark;

    if (isAnswered) {
      if (isSelected && option.isCorrect) {
        // Seleccionó correcta → verde fuerte
        bgColor = const Color(0xFF4CAF50);
        borderColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
      } else if (isSelected && !option.isCorrect) {
        // Seleccionó incorrecta → rojo
        bgColor = const Color(0xFFE53935);
        borderColor = const Color(0xFFE53935);
        textColor = Colors.white;
      } else if (!isSelected && option.isCorrect) {
        // NO seleccionó pero era correcta → verde suave (para que sepa)
        bgColor = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF2E7D32);
      }
      // Incorrectas no seleccionadas quedan neutras
    } else if (isSelected) {
      bgColor = const Color(0xFF2196F3);
      borderColor = const Color(0xFF2196F3);
      textColor = Colors.white;
    }

    final showCheck = isSelected;

    return GestureDetector(
      onTap: isAnswered
          ? null
          : () {
              HapticFeedback.lightImpact();
              onAnswer(option.isCorrect, option.id);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 3),
        ),
        child: Row(
          children: [
            // Checkbox simple
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: showCheck
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: showCheck ? Colors.white : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: showCheck
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            // Texto
            Expanded(
              child: Text(
                option.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.05);
  }

  Widget _buildVerifyButton() {
    final hasSelection = selectedOptionIds.isNotEmpty;

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
              hasSelection ? '¡VERIFICAR! ✓' : 'Elige una opción',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
