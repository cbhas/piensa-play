import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/unified_question.dart';

/// Widget para preguntas tipo "Completar texto"
/// El usuario rellena espacios en blanco con palabras del banco
class FillBlankWidget extends StatefulWidget {
  final UnifiedQuestion question;
  final bool isAnswered;
  final List<String> userAnswers;
  final Function(int blankIndex, String word) onWordPlaced;
  final VoidCallback onVerify;

  const FillBlankWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.userAnswers,
    required this.onWordPlaced,
    required this.onVerify,
  });

  @override
  State<FillBlankWidget> createState() => _FillBlankWidgetState();
}

class _FillBlankWidgetState extends State<FillBlankWidget> {
  int? _selectedBlankIndex;

  // Palabras disponibles (no usadas aún)
  List<String> get availableWords {
    final wordBank = widget.question.wordBank ?? [];
    final usedWords = widget.userAnswers.where((w) => w.isNotEmpty).toSet();
    return wordBank.where((w) => !usedWords.contains(w)).toList();
  }

  // Verificar si todos los espacios están llenos
  bool get allBlanksFilled {
    final blankCount = widget.question.blankAnswers?.length ?? 0;
    if (widget.userAnswers.length < blankCount) return false;
    return widget.userAnswers.take(blankCount).every((w) => w.isNotEmpty);
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícono
                  Center(
                    child:
                        Icon(
                          Icons.edit_rounded,
                          size: 48,
                          color: AppTheme.primaryDark,
                        ).animate().scale(
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Título
                  Center(
                    child: Text(
                      widget.question.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                        height: 1.3,
                      ),
                    ),
                  ),

                  if (widget.question.subtitle != null) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        widget.question.subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Texto con espacios en blanco
                  _buildTextWithBlanks(),

                  const SizedBox(height: 32),

                  // Banco de palabras
                  Text(
                    'Banco de palabras:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildWordBank(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Botón verificar
          if (!widget.isAnswered)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: allBlanksFilled ? widget.onVerify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    allBlanksFilled
                        ? 'Verificar'
                        : 'Completa todos los espacios',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
        ],
      ),
    );
  }

  /// Construye el texto con espacios en blanco interactivos
  Widget _buildTextWithBlanks() {
    final text = widget.question.textWithBlanks ?? '';
    final parts = text.split('_____');
    final blankCount = parts.length - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            // Texto antes del espacio
            if (parts[i].isNotEmpty)
              Text(
                parts[i],
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.primaryDark,
                  height: 1.6,
                ),
              ),
            // Espacio en blanco (si no es el último parte)
            if (i < blankCount) _buildBlankSlot(i),
          ],
        ],
      ),
    );
  }

  /// Construye un espacio en blanco individual (ahora es DragTarget)
  Widget _buildBlankSlot(int index) {
    final hasWord =
        index < widget.userAnswers.length &&
        widget.userAnswers[index].isNotEmpty;
    final word = hasWord ? widget.userAnswers[index] : '';
    final isSelected = _selectedBlankIndex == index;

    // Verificar si es correcto (solo en modo respuesta)
    bool? isCorrect;
    if (widget.isAnswered && hasWord) {
      final correctAnswers = widget.question.blankAnswers ?? [];
      if (index < correctAnswers.length) {
        isCorrect = word.toLowerCase() == correctAnswers[index].toLowerCase();
      }
    }

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        if (!widget.isAnswered) {
          widget.onWordPlaced(index, details.data);
          setState(() {
            _selectedBlankIndex = null;
          });
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        Color bgColor = isSelected || isHovering
            ? AppTheme.accentBlue.withValues(alpha: 0.15)
            : Colors.white;
        Color borderColor = isSelected || isHovering
            ? AppTheme.accentBlue
            : Colors.grey.shade400;

        if (widget.isAnswered && isCorrect != null) {
          if (isCorrect) {
            bgColor = Colors.green.shade50;
            borderColor = Colors.green;
          } else {
            bgColor = Colors.red.shade50;
            borderColor = Colors.red;
          }
        }

        return GestureDetector(
          onTap: widget.isAnswered
              ? null
              : () {
                  setState(() {
                    if (hasWord) {
                      widget.onWordPlaced(index, '');
                      _selectedBlankIndex = null;
                    } else {
                      _selectedBlankIndex = isSelected ? null : index;
                    }
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            constraints: const BoxConstraints(minWidth: 80),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: isSelected || isHovering ? 2 : 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasWord ? word : '______',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: hasWord
                        ? AppTheme.primaryDark
                        : Colors.grey.shade400,
                  ),
                ),
                if (widget.isAnswered && isCorrect != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ] else if (hasWord && !widget.isAnswered) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.close, size: 14, color: Colors.grey.shade500),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construye el banco de palabras (ahora con Draggable)
  Widget _buildWordBank() {
    final allWords = widget.question.wordBank ?? [];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: allWords.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        final isUsed = widget.userAnswers.contains(word);

        if (isUsed || widget.isAnswered) {
          // Palabra usada o ya respondido - sin drag
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              word,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                decoration: isUsed ? TextDecoration.lineThrough : null,
              ),
            ),
          ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
        }

        // Palabra disponible - con Draggable
        return Draggable<String>(
          data: word,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                word,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          childWhenDragging: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              word,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          child: GestureDetector(
            onTap: _selectedBlankIndex == null
                ? null
                : () {
                    widget.onWordPlaced(_selectedBlankIndex!, word);
                    setState(() {
                      _selectedBlankIndex = null;
                    });
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedBlankIndex != null
                    ? AppTheme.accentBlue.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedBlankIndex != null
                      ? AppTheme.accentBlue
                      : Colors.grey.shade400,
                  width: _selectedBlankIndex != null ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.drag_indicator,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    word,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1),
        );
      }).toList(),
    );
  }
}
