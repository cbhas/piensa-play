// lib/features/glossary/domain/entities/glossary_term.dart

class GlossaryTerm {
  final String id;
  final String term;
  final String category;
  final String definition;
  final String icon;
  final int order;
  final String question;

  const GlossaryTerm({
    required this.id,
    required this.term,
    required this.category,
    required this.definition,
    required this.icon,
    required this.order,
    required this.question,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'term': term,
    'category': category,
    'definition': definition,
    'icon': icon,
    'order': order,
    'question': question,
  };

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) => GlossaryTerm(
    id: json['id'] ?? json['order']?.toString() ?? '',
    term: json['term'] ?? '',
    category: json['category'] ?? '',
    definition: json['definition'] ?? '',
    icon: json['icon'] ?? '📖',
    order: json['order'] ?? 0,
    question: json['question'] ?? '',
  );

  GlossaryTerm copyWith({
    String? id,
    String? term,
    String? category,
    String? definition,
    String? icon,
    int? order,
    String? question,
  }) {
    return GlossaryTerm(
      id: id ?? this.id,
      term: term ?? this.term,
      category: category ?? this.category,
      definition: definition ?? this.definition,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      question: question ?? this.question,
    );
  }
}
