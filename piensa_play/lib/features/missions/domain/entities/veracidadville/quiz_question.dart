import 'quiz_element.dart';

class QuizQuestion {
  final String id;
  final String newsTitle;
  final String newsContent;
  final String newsSource;
  final String newsDate;
  final String newsAuthor;
  final String newsShares;
  final String? newsImage;
  final List<QuizElement> elements;
  final String explanation;

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
  });

  int get correctAnswersCount => elements.where((e) => e.isCorrect).length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'newsTitle': newsTitle,
    'newsContent': newsContent,
    'newsSource': newsSource,
    'newsDate': newsDate,
    'newsAuthor': newsAuthor,
    'newsShares': newsShares,
    'newsImage': newsImage,
    'elements': elements.map((e) => e.toJson()).toList(),
    'explanation': explanation,
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json['id'] ?? '',
    newsTitle: json['newsTitle'] ?? '',
    newsContent: json['newsContent'] ?? '',
    newsSource: json['newsSource'] ?? '',
    newsDate: json['newsDate'] ?? '',
    newsAuthor: json['newsAuthor'] ?? '',
    newsShares: json['newsShares'] ?? '',
    newsImage: json['newsImage'],
    elements:
        (json['elements'] as List<dynamic>?)
            ?.map((e) => QuizElement.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    explanation: json['explanation'] ?? '',
  );
}
