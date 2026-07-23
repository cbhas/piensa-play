import '../../../../../core/localization/localized_text.dart';

class QuizElement {
  final String id;
  final LocalizedText text;
  final String icon;
  final bool isCorrect;

  const QuizElement({
    required this.id,
    required this.text,
    required this.icon,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text.toJson(),
    'icon': icon,
    'isCorrect': isCorrect,
  };

  factory QuizElement.fromJson(Map<String, dynamic> json) => QuizElement(
    id: json['id'] ?? '',
    text: LocalizedText.fromJson(json['text']),
    icon: json['icon'] ?? '',
    isCorrect: json['isCorrect'] ?? false,
  );
}
