// lib/features/glossary/domain/entities/glossary_term.dart

class GlossaryTerm {
  final String id;
  final String term;
  final String category;
  final String definition;
  final String icon;
  final int order;
  final String question;
  final String?
  audioFileName; // Nombre del archivo de audio (ej: "fake_news.mp3")

  const GlossaryTerm({
    required this.id,
    required this.term,
    required this.category,
    required this.definition,
    required this.icon,
    required this.order,
    required this.question,
    this.audioFileName,
  });

  /// Genera el nombre del archivo de audio basado en el término
  /// Si hay audioFileName explícito lo usa, sino lo genera del término
  String get effectiveAudioFileName {
    if (audioFileName != null && audioFileName!.isNotEmpty) {
      return audioFileName!;
    }
    // Generar nombre del término
    return '${_sanitizeTermName(term)}.mp3';
  }

  /// Sanitiza el nombre del término para coincidir con archivo de audio
  static String _sanitizeTermName(String termName) {
    return termName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll(RegExp(r'[^\w_]'), '');
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'term': term,
    'category': category,
    'definition': definition,
    'icon': icon,
    'order': order,
    'question': question,
    'audioFileName': audioFileName,
  };

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) => GlossaryTerm(
    id: json['id'] ?? json['order']?.toString() ?? '',
    term: json['term'] ?? '',
    category: json['category'] ?? '',
    definition: json['definition'] ?? '',
    icon: json['icon'] ?? '📖',
    order: json['order'] ?? 0,
    question: json['question'] ?? '',
    audioFileName: json['audioFileName'],
  );

  GlossaryTerm copyWith({
    String? id,
    String? term,
    String? category,
    String? definition,
    String? icon,
    int? order,
    String? question,
    String? audioFileName,
  }) {
    return GlossaryTerm(
      id: id ?? this.id,
      term: term ?? this.term,
      category: category ?? this.category,
      definition: definition ?? this.definition,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      question: question ?? this.question,
      audioFileName: audioFileName ?? this.audioFileName,
    );
  }
}
