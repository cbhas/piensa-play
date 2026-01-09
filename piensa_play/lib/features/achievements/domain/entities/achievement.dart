/// Constantes de gamificación
class GamificationConfig {
  static const int xpPerMission = 100;
  static const int xpPerCategory = 250;
  static const int coinsPerMission = 50;
  static const int xpToLevelUp = 300;
}

class Achievement {
  final int currentLevel;
  final int totalXP;
  final int coins;

  const Achievement({
    required this.currentLevel,
    required this.totalXP,
    required this.coins,
  });

  /// XP actual dentro del nivel (0-299)
  int get currentLevelXP => totalXP % GamificationConfig.xpToLevelUp;

  /// Progreso hacia el siguiente nivel (0.0 - 1.0)
  double get levelProgress => currentLevelXP / GamificationConfig.xpToLevelUp;

  /// XP restante para subir de nivel
  int get xpToNextLevel => GamificationConfig.xpToLevelUp - currentLevelXP;

  /// Crea una copia con valores actualizados
  Achievement copyWith({int? currentLevel, int? totalXP, int? coins}) {
    return Achievement(
      currentLevel: currentLevel ?? this.currentLevel,
      totalXP: totalXP ?? this.totalXP,
      coins: coins ?? this.coins,
    );
  }

  /// Calcula el nivel basado en XP total
  static int calculateLevel(int totalXP) {
    return totalXP ~/ GamificationConfig.xpToLevelUp;
  }

  Map<String, dynamic> toJson() => {
    'currentLevel': currentLevel,
    'totalXP': totalXP,
    'coins': coins,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    currentLevel: json['currentLevel'] ?? 0,
    totalXP: json['totalXP'] ?? 0,
    coins: json['coins'] ?? 0,
  );

  /// Achievement inicial para nuevos usuarios
  factory Achievement.initial() =>
      const Achievement(currentLevel: 0, totalXP: 0, coins: 0);
}
