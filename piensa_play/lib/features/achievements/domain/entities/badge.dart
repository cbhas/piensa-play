class Badge {
  final String id;
  final String title;
  final String? description;
  final String iconName;
  final bool isUnlocked;

  const Badge({
    required this.id,
    required this.title,
    this.description,
    required this.iconName,
    required this.isUnlocked,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'iconName': iconName,
    'isUnlocked': isUnlocked,
  };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'],
    iconName: json['iconName'] ?? '',
    isUnlocked: json['isUnlocked'] ?? false,
  );
}
