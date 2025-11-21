class Achievement {
  final double generalProgress;
  final int currentLevel;
  final int totalXP;
  final int coins;

  const Achievement({
    required this.generalProgress,
    required this.currentLevel,
    required this.totalXP,
    required this.coins,
  });

  Map<String, dynamic> toJson() => {
    'generalProgress': generalProgress,
    'currentLevel': currentLevel,
    'totalXP': totalXP,
    'coins': coins,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    generalProgress: (json['generalProgress'] as num?)?.toDouble() ?? 0.0,
    currentLevel: json['currentLevel'] ?? 0,
    totalXP: json['totalXP'] ?? 0,
    coins: json['coins'] ?? 0,
  );
}
