class DashboardStats {
  final int newGames;
  final int pendingGlossary;
  final int achievements;
  final int activeMissions;

  const DashboardStats({
    required this.newGames,
    required this.pendingGlossary,
    required this.achievements,
    required this.activeMissions,
  });

  Map<String, dynamic> toJson() => {
    'newGames': newGames,
    'pendingGlossary': pendingGlossary,
    'achievements': achievements,
    'activeMissions': activeMissions,
  };

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    newGames: json['newGames'] ?? 0,
    pendingGlossary: json['pendingGlossary'] ?? 0,
    achievements: json['achievements'] ?? 0,
    activeMissions: json['activeMissions'] ?? 0,
  );
}
