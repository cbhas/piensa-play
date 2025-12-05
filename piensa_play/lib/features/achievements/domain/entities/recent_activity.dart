class RecentActivity {
  final String id;
  final String description;
  final int xpReward;
  final String iconName;
  final bool isCompleted;

  const RecentActivity({
    required this.id,
    required this.description,
    required this.xpReward,
    required this.iconName,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'xpReward': xpReward,
    'iconName': iconName,
    'isCompleted': isCompleted,
  };

  factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
    id: json['id'] ?? '',
    description: json['description'] ?? '',
    xpReward: json['xpReward'] ?? 0,
    iconName: json['iconName'] ?? '',
    isCompleted: json['isCompleted'] ?? false,
  );
}
