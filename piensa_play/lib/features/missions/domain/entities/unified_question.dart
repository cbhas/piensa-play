/// Modelo unificado de pregunta para el sistema de misiones
/// Soporta todos los tipos: quiz, trueFalse, wordSelection, stereotype,
/// classify, fillBlank, matchPairs

enum QuestionType {
  quiz, // Selección múltiple
  trueFalse, // Verdadero/Falso
  wordSelection, // Selección de palabras
  stereotype, // Rompe estereotipos
  classify, // Arrastrar a categorías
  fillBlank, // Completar texto
  matchPairs, // Conectar parejas
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
      case QuestionType.classify:
        return 'classify';
      case QuestionType.fillBlank:
        return 'fillBlank';
      case QuestionType.matchPairs:
        return 'matchPairs';
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
      case 'classify':
        return QuestionType.classify;
      case 'fillBlank':
        return QuestionType.fillBlank;
      case 'matchPairs':
        return QuestionType.matchPairs;
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

/// Item clasificable para tipo classify
class ClassifyItem {
  final String id;
  final String text;
  final String correctCategory;

  const ClassifyItem({
    required this.id,
    required this.text,
    required this.correctCategory,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'correctCategory': correctCategory,
  };

  factory ClassifyItem.fromJson(Map<String, dynamic> json) => ClassifyItem(
    id: json['id'] ?? '',
    text: json['text'] ?? '',
    correctCategory: json['correctCategory'] ?? '',
  );
}

/// Par para tipo matchPairs
class MatchPair {
  final String id;
  final String left;
  final String right;

  const MatchPair({required this.id, required this.left, required this.right});

  Map<String, dynamic> toJson() => {'id': id, 'left': left, 'right': right};

  factory MatchPair.fromJson(Map<String, dynamic> json) => MatchPair(
    id: json['id'] ?? '',
    left: json['left'] ?? '',
    right: json['right'] ?? '',
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

  // Campos para quiz/trueFalse
  final bool? correctBoolAnswer; // Para trueFalse
  final List<String>? correctWords; // Para wordSelection
  final String? source; // Para quiz (fuente de noticia)
  final String? date; // Para quiz (fecha de noticia)

  // Campos para classify
  final List<String>? categories; // Nombres de categorías
  final List<ClassifyItem>? classifyItems; // Items a clasificar

  // Campos para fillBlank
  final String? textWithBlanks; // Texto con _____ para espacios
  final List<String>? blankAnswers; // Respuestas correctas en orden
  final List<String>? wordBank; // Banco de palabras disponibles

  // Campos para matchPairs
  final List<MatchPair>? matchPairs; // Parejas correctas

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
    this.categories,
    this.classifyItems,
    this.textWithBlanks,
    this.blankAnswers,
    this.wordBank,
    this.matchPairs,
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

  /// Para classify, verifica si la clasificación es correcta
  bool isClassificationCorrect(Map<String, String> userClassification) {
    if (classifyItems == null) return false;
    for (final item in classifyItems!) {
      if (userClassification[item.id] != item.correctCategory) {
        return false;
      }
    }
    return true;
  }

  /// Para fillBlank, verifica si las respuestas son correctas
  bool areBlanksCorrect(List<String> userAnswers) {
    if (blankAnswers == null) return false;
    if (userAnswers.length != blankAnswers!.length) return false;
    for (int i = 0; i < blankAnswers!.length; i++) {
      if (userAnswers[i].toLowerCase() != blankAnswers![i].toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  /// Para matchPairs, verifica si las conexiones son correctas
  bool areMatchesCorrect(Map<String, String> userMatches) {
    if (matchPairs == null) return false;
    for (final pair in matchPairs!) {
      if (userMatches[pair.left] != pair.right) {
        return false;
      }
    }
    return true;
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
    'categories': categories,
    'classifyItems': classifyItems?.map((i) => i.toJson()).toList(),
    'textWithBlanks': textWithBlanks,
    'blankAnswers': blankAnswers,
    'wordBank': wordBank,
    'matchPairs': matchPairs?.map((p) => p.toJson()).toList(),
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
        categories: (json['categories'] as List<dynamic>?)?.cast<String>(),
        classifyItems: (json['classifyItems'] as List<dynamic>?)
            ?.map((i) => ClassifyItem.fromJson(i as Map<String, dynamic>))
            .toList(),
        textWithBlanks: json['textWithBlanks'],
        blankAnswers: (json['blankAnswers'] as List<dynamic>?)?.cast<String>(),
        wordBank: (json['wordBank'] as List<dynamic>?)?.cast<String>(),
        matchPairs: (json['matchPairs'] as List<dynamic>?)
            ?.map((p) => MatchPair.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
}
