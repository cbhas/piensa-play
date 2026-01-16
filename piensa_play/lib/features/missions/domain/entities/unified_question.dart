/// Modelo unificado de pregunta para el sistema de misiones
/// Soporta todos los tipos: quiz, trueFalse, wordSelection, stereotype

enum QuestionType {
  quiz, // Selección múltiple
  trueFalse, // Verdadero/Falso
  wordSelection, // Selección de palabras
  stereotype, // Rompe estereotipos
}

extension QuestionTypeExtension on QuestionType {
  String toJson() {
    switch (this) {
      case QuestionType.quiz:
        return 'quiz';
      case QuestionType.trueFalse:
        return 'trueFalse';
      case QuestionType.wordSelection:
        return 'wordSelection';
      case QuestionType.stereotype:
        return 'stereotype';
    }
  }

  static QuestionType fromJson(String? value) {
    switch (value) {
      case 'quiz':
        return QuestionType.quiz;
      case 'trueFalse':
        return QuestionType.trueFalse;
      case 'wordSelection':
        return QuestionType.wordSelection;
      case 'stereotype':
        return QuestionType.stereotype;
      default:
        return QuestionType.quiz;
    }
  }
}

/// Opción de respuesta genérica
class AnswerOption {
  final String id;
  final String text;
  final bool isCorrect;
  final String? imageUrl;
  final String? feedback; // Retroalimentación específica de esta opción

  const AnswerOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.imageUrl,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCorrect': isCorrect,
    'imageUrl': imageUrl,
    'feedback': feedback,
  };

  factory AnswerOption.fromJson(Map<String, dynamic> json) => AnswerOption(
    id: json['id'] ?? '',
    text: json['text'] ?? '',
    isCorrect: json['isCorrect'] ?? false,
    imageUrl: json['imageUrl'],
    feedback: json['feedback'],
  );
}

/// Pregunta unificada que soporta todos los tipos de misión
class UnifiedQuestion {
  final String id;
  final QuestionType type;
  final String title; // Pregunta principal o título
  final String? subtitle; // Instrucción o contexto adicional
  final String? content; // Contenido largo (ej: noticia falsa)
  final String? imageUrl; // Imagen opcional
  final List<AnswerOption> options; // Opciones de respuesta
  final String explanation; // Explicación cuando es CORRECTO
  final String? incorrectExplanation; // Explicación cuando es INCORRECTO

  // Campos específicos por tipo (opcionales)
  final bool? correctBoolAnswer; // Para trueFalse
  final List<String>? correctWords; // Para wordSelection
  final String? source; // Para quiz (fuente de noticia)
  final String? date; // Para quiz (fecha de noticia)

  const UnifiedQuestion({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.content,
    this.imageUrl,
    required this.options,
    required this.explanation,
    this.incorrectExplanation,
    this.correctBoolAnswer,
    this.correctWords,
    this.source,
    this.date,
  });

  /// Verifica si una respuesta es correcta
  bool isAnswerCorrect(String optionId) {
    final option = options.firstWhere(
      (o) => o.id == optionId,
      orElse: () => const AnswerOption(id: '', text: '', isCorrect: false),
    );
    return option.isCorrect;
  }

  /// Para trueFalse, verifica si la respuesta booleana es correcta
  bool isBoolAnswerCorrect(bool answer) {
    return correctBoolAnswer == answer;
  }

  /// Para wordSelection, verifica si las palabras seleccionadas son correctas
  bool areWordsCorrect(List<String> selectedWords) {
    if (correctWords == null) return false;
    return correctWords!.toSet().containsAll(selectedWords.toSet()) &&
        selectedWords.toSet().containsAll(correctWords!.toSet());
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toJson(),
    'title': title,
    'subtitle': subtitle,
    'content': content,
    'imageUrl': imageUrl,
    'options': options.map((o) => o.toJson()).toList(),
    'explanation': explanation,
    'incorrectExplanation': incorrectExplanation,
    'correctBoolAnswer': correctBoolAnswer,
    'correctWords': correctWords,
    'source': source,
    'date': date,
  };

  factory UnifiedQuestion.fromJson(Map<String, dynamic> json) =>
      UnifiedQuestion(
        id: json['id'] ?? '',
        type: QuestionTypeExtension.fromJson(json['type']),
        title: json['title'] ?? '',
        subtitle: json['subtitle'],
        content: json['content'],
        imageUrl: json['imageUrl'],
        options:
            (json['options'] as List<dynamic>?)
                ?.map((o) => AnswerOption.fromJson(o as Map<String, dynamic>))
                .toList() ??
            [],
        explanation: json['explanation'] ?? '',
        incorrectExplanation: json['incorrectExplanation'],
        correctBoolAnswer: json['correctBoolAnswer'],
        correctWords: (json['correctWords'] as List<dynamic>?)?.cast<String>(),
        source: json['source'],
        date: json['date'],
      );
}
