import 'package:flutter/material.dart';
import '../../../domain/entities/unified_question.dart';

/// Widget base abstracto para todos los tipos de pregunta
/// Cada tipo de pregunta debe implementar esta interfaz
abstract class BaseQuestionWidget extends StatelessWidget {
  final UnifiedQuestion question;
  final Function(bool isCorrect, String? selectedOptionId) onAnswer;
  final bool isAnswered;

  const BaseQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswer,
    this.isAnswered = false,
  });
}
