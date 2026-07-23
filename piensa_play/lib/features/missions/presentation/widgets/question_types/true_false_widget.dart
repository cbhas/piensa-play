import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import 'base_question_widget.dart';

/// Widget Verdadero/Falso - Diseño MINIMALISTA para niños
class TrueFalseWidget extends BaseQuestionWidget {
  final bool? selectedAnswer;
  final VoidCallback? onVerify;

  const TrueFalseWidget({
    super.key,
    required super.question,
    required super.onAnswer,
    super.isAnswered,
    this.selectedAnswer,
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
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
                  const SizedBox(height: 20),

                  // Ícono grande
                  const Icon(
                    Icons.search_rounded,
                    size: 56,
                    color: AppTheme.primaryDark,
                  ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 20),

                  // Pregunta
                  Text(
                    question.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Contenido/noticia (corto)
                  if (question.content != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1), // Amarillo suave
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber.shade200,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.newspaper_rounded,
                            size: 28,
                            color: AppTheme.primaryDark,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _shortenText(question.content!, 220),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Botones V/F grandes
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(isTrue: true, english: english),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildButton(isTrue: false, english: english),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Botón verificar
          if (!isAnswered) _buildVerifyButton(english),
        ],
      ),
    );
  }

  String _shortenText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Widget _buildButton({required bool isTrue, required bool english}) {
    final isSelected = selectedAnswer == isTrue;
    final isCorrect = question.correctBoolAnswer == isTrue;

    // Colores base
    final baseColor = isTrue
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);

    // Estado
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;

    if (isAnswered) {
      if (isCorrect) {
        bgColor = const Color(0xFF4CAF50);
        borderColor = const Color(0xFF4CAF50);
      } else if (isSelected) {
        bgColor = const Color(0xFFE53935);
        borderColor = const Color(0xFFE53935);
      }
    } else if (isSelected) {
      bgColor = baseColor;
      borderColor = baseColor;
    }

    final isHighlighted = isSelected || (isAnswered && isCorrect);

    return GestureDetector(
          onTap: isAnswered
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onAnswer(false, isTrue ? 'true' : 'false');
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 140,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 4),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isTrue ? Icons.check_rounded : Icons.close_rounded,
                  size: 40,
                  color: isHighlighted ? Colors.white : baseColor,
                ),
                const SizedBox(height: 8),
                Text(
                  isTrue
                      ? (english ? 'TRUE' : 'VERDADERO')
                      : (english ? 'FALSE' : 'FALSO'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted ? Colors.white : baseColor,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: (isTrue ? 100 : 150).ms)
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildVerifyButton(bool english) {
    final hasSelection = selectedAnswer != null;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasSelection
                      ? (english ? 'CHECK!' : '¡VERIFICAR!')
                      : (english ? 'Choose an option' : 'Elige una opción'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasSelection) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_rounded),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
