class Badge {
  final String id;
  final String title;
  final String iconName;
  final bool isUnlocked;

  const Badge({
    required this.id,
    required this.title,
    required this.iconName,
    required this.isUnlocked,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'iconName': iconName,
    'isUnlocked': isUnlocked,
  };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    iconName: json['iconName'] ?? '',
    isUnlocked: json['isUnlocked'] ?? false,
  );
}
