enum QuestionType {
  quiz, // Select elements (Veracidadville fake_news, Ciberseguridad)
  trueFalse, // True/False (Veracidadville titular)
  wordSelection, // Select words (Zona Cero words)
  stereotype, // Fix stereotypes (Zona Cero stereotypes)
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

  static QuestionType fromJson(String value) {
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
        return QuestionType.quiz; // Default fallback
    }
  }
}
