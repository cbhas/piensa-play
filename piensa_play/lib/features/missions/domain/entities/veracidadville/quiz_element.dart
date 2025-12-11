class QuizElement {
  final String id;
  final String text;
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
    'text': text,
    'icon': icon,
    'isCorrect': isCorrect,
  };

  factory QuizElement.fromJson(Map<String, dynamic> json) => QuizElement(
    id: json['id'] ?? '',
    text: json['text'] ?? '',
    icon: json['icon'] ?? '',
    isCorrect: json['isCorrect'] ?? false,
  );
}
