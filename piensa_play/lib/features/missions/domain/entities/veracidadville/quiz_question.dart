import '../../../../../core/localization/localized_text.dart';
import 'quiz_element.dart';
import 'question_type.dart';

class QuizQuestion {
  final String id;
  final LocalizedText newsTitle;
  final LocalizedText newsContent;
  final LocalizedText newsSource;
  final LocalizedText newsDate;
  final LocalizedText newsAuthor;
  final LocalizedText newsShares;
  final String? newsImage;
  final List<QuizElement> elements;
  final LocalizedText explanation;

  // NEW: Optional fields for unified model
  final QuestionType type; // Type of question
  final bool? correctAnswer; // For trueFalse type
  final List<LocalizedText>? clues; // For trueFalse type (hints)

  const QuizQuestion({
    required this.id,
    required this.newsTitle,
    required this.newsContent,
    required this.newsSource,
    required this.newsDate,
    required this.newsAuthor,
    required this.newsShares,
    this.newsImage,
    required this.elements,
    required this.explanation,
    this.type = QuestionType.quiz, // Default to quiz type
    this.correctAnswer,
    this.clues,
  });

  int get correctAnswersCount => elements.where((e) => e.isCorrect).length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'newsTitle': newsTitle.toJson(),
    'newsContent': newsContent.toJson(),
    'newsSource': newsSource.toJson(),
    'newsDate': newsDate.toJson(),
    'newsAuthor': newsAuthor.toJson(),
    'newsShares': newsShares.toJson(),
    'newsImage': newsImage,
    'elements': elements.map((e) => e.toJson()).toList(),
    'explanation': explanation.toJson(),
    'type': type.toJson(),
    'correctAnswer': correctAnswer,
    'clues': clues?.map((c) => c.toJson()).toList(),
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json['id'] ?? '',
    newsTitle: LocalizedText.fromJson(json['newsTitle']),
    newsContent: LocalizedText.fromJson(json['newsContent']),
    newsSource: LocalizedText.fromJson(json['newsSource']),
    newsDate: LocalizedText.fromJson(json['newsDate']),
    newsAuthor: LocalizedText.fromJson(json['newsAuthor']),
    newsShares: LocalizedText.fromJson(json['newsShares']),
    newsImage: json['newsImage'],
    elements:
        (json['elements'] as List<dynamic>?)
            ?.map((e) => QuizElement.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    explanation: LocalizedText.fromJson(json['explanation']),
    type: json['type'] != null
        ? QuestionTypeExtension.fromJson(json['type'] as String)
        : QuestionType.quiz,
    correctAnswer: json['correctAnswer'] as bool?,
    clues: (json['clues'] as List<dynamic>?)
        ?.map((c) => LocalizedText.fromJson(c))
        .toList(),
  );
}
