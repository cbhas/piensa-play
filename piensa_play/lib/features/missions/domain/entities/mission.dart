import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_question.dart';

/// Tipos de misión que determinan qué página de juego mostrar
enum MissionType {
  quiz, // Quiz de selección múltiple
  trueFalse, // Verdadero/Falso
  wordSelection, // Selección de palabras
  stereotype, // Rompe estereotipos
}

class Mission {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final bool isCompleted;
  final String iconName;
  final MissionType type; // Tipo de misión para determinar la página
  final List<QuizQuestion>? questions;

  Mission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.isCompleted,
    required this.iconName,
    this.type = MissionType.quiz, // Default quiz
    this.questions,
  });

  /// Crea una copia de la misión con valores actualizados
  Mission copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    bool? isCompleted,
    String? iconName,
    MissionType? type,
    List<QuizQuestion>? questions,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      iconName: iconName ?? this.iconName,
      type: type ?? this.type,
      questions: questions ?? this.questions,
    );
  }
}

extension MissionTypeExtension on MissionType {
  String toJson() {
    switch (this) {
      case MissionType.quiz:
        return 'quiz';
      case MissionType.trueFalse:
        return 'trueFalse';
      case MissionType.wordSelection:
        return 'wordSelection';
      case MissionType.stereotype:
        return 'stereotype';
    }
  }

  static MissionType fromJson(String? value) {
    switch (value) {
      case 'quiz':
        return MissionType.quiz;
      case 'trueFalse':
        return MissionType.trueFalse;
      case 'wordSelection':
        return MissionType.wordSelection;
      case 'stereotype':
        return MissionType.stereotype;
      default:
        return MissionType.quiz;
    }
  }
}
