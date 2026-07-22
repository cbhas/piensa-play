import '../../features/achievements/domain/entities/achievement.dart';

class MissionRewardDecision {
  final bool grantMissionReward;
  final bool grantCategoryBonus;

  const MissionRewardDecision({
    required this.grantMissionReward,
    required this.grantCategoryBonus,
  });

  int get xp => grantMissionReward
      ? GamificationConfig.xpPerMission +
            (grantCategoryBonus ? GamificationConfig.xpPerCategory : 0)
      : 0;

  int get coins => grantMissionReward ? GamificationConfig.coinsPerMission : 0;
}

class MissionRewardPolicy {
  static MissionRewardDecision decide({
    required bool missionAlreadyCompleted,
    required bool allOtherMissionsCompleted,
    required bool categoryBonusAlreadyClaimed,
  }) {
    if (missionAlreadyCompleted) {
      return const MissionRewardDecision(
        grantMissionReward: false,
        grantCategoryBonus: false,
      );
    }
    return MissionRewardDecision(
      grantMissionReward: true,
      grantCategoryBonus:
          allOtherMissionsCompleted && !categoryBonusAlreadyClaimed,
    );
  }
}

class DailyRewardDecision {
  final bool grantReward;
  final int xp;
  final int coins;
  final int streak;
  final int bestStreak;
  final int totalAnswered;
  final int totalCorrect;

  const DailyRewardDecision({
    required this.grantReward,
    required this.xp,
    required this.coins,
    required this.streak,
    required this.bestStreak,
    required this.totalAnswered,
    required this.totalCorrect,
  });
}

class DailyRewardPolicy {
  static DailyRewardDecision decide({
    required bool isCorrect,
    required String today,
    required String yesterday,
    required String? lastAnsweredDate,
    required int currentStreak,
    required int currentBestStreak,
    required int currentTotalAnswered,
    required int currentTotalCorrect,
  }) {
    if (lastAnsweredDate == today) {
      return DailyRewardDecision(
        grantReward: false,
        xp: 0,
        coins: 0,
        streak: currentStreak,
        bestStreak: currentBestStreak,
        totalAnswered: currentTotalAnswered,
        totalCorrect: currentTotalCorrect,
      );
    }

    final streak = lastAnsweredDate == yesterday ? currentStreak + 1 : 1;
    return DailyRewardDecision(
      grantReward: true,
      xp: isCorrect
          ? GamificationConfig.xpPerDailyCorrect
          : GamificationConfig.xpPerDailyIncorrect,
      coins: isCorrect
          ? GamificationConfig.coinsPerDailyCorrect
          : GamificationConfig.coinsPerDailyIncorrect,
      streak: streak,
      bestStreak: streak > currentBestStreak ? streak : currentBestStreak,
      totalAnswered: currentTotalAnswered + 1,
      totalCorrect: currentTotalCorrect + (isCorrect ? 1 : 0),
    );
  }
}
