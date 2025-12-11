class TrueFalseQuestion {
  final String id;
  final String newsSource;
  final String newsAuthor;
  final String newsDate;
  final String newsTitle;
  final String newsContent;
  final String? newsImage;
  final String newsShares;
  final bool isTrue; // true = verdadero, false = falso
  final List<String> clues; // Pistas a detectar

  const TrueFalseQuestion({
    required this.id,
    required this.newsSource,
    required this.newsAuthor,
    required this.newsDate,
    required this.newsTitle,
    required this.newsContent,
    this.newsImage,
    required this.newsShares,
    required this.isTrue,
    required this.clues,
  });
}
