class Mission {
  final String title;
  final String description;
  final String buttonText;
  final bool isActive;

  const Mission({
    required this.title,
    required this.description,
    required this.buttonText,
    this.isActive = true,
  });
}
