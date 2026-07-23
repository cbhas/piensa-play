import 'package:flutter_test/flutter_test.dart';
import 'package:piensa_play/core/domain/reward_policy.dart';
import 'package:piensa_play/features/achievements/domain/entities/achievement.dart';

void main() {
  group('MissionRewardPolicy', () {
    test('does not reward a replay', () {
      final result = MissionRewardPolicy.decide(
        missionAlreadyCompleted: true,
        allOtherMissionsCompleted: true,
        categoryBonusAlreadyClaimed: false,
      );

      expect(result.grantMissionReward, isFalse);
      expect(result.grantCategoryBonus, isFalse);
      expect(result.xp, 0);
      expect(result.coins, 0);
    });

    test('grants category bonus once on the final mission', () {
      final first = MissionRewardPolicy.decide(
        missionAlreadyCompleted: false,
        allOtherMissionsCompleted: true,
        categoryBonusAlreadyClaimed: false,
      );
      final alreadyClaimed = MissionRewardPolicy.decide(
        missionAlreadyCompleted: false,
        allOtherMissionsCompleted: true,
        categoryBonusAlreadyClaimed: true,
      );

      expect(first.grantCategoryBonus, isTrue);
      expect(
        first.xp,
        GamificationConfig.xpPerMission + GamificationConfig.xpPerCategory,
      );
      expect(alreadyClaimed.grantCategoryBonus, isFalse);
      expect(alreadyClaimed.xp, GamificationConfig.xpPerMission);
    });
  });

  group('DailyRewardPolicy', () {
    test('is idempotent for the same day', () {
      final result = DailyRewardPolicy.decide(
        isCorrect: true,
        today: '2026-07-21',
        yesterday: '2026-07-20',
        lastAnsweredDate: '2026-07-21',
        currentStreak: 4,
        currentBestStreak: 6,
        currentTotalAnswered: 10,
        currentTotalCorrect: 8,
      );

      expect(result.grantReward, isFalse);
      expect(result.xp, 0);
      expect(result.totalAnswered, 10);
      expect(result.totalCorrect, 8);
    });

    test('continues streak only from yesterday', () {
      final continued = DailyRewardPolicy.decide(
        isCorrect: false,
        today: '2026-07-21',
        yesterday: '2026-07-20',
        lastAnsweredDate: '2026-07-20',
        currentStreak: 4,
        currentBestStreak: 4,
        currentTotalAnswered: 10,
        currentTotalCorrect: 8,
      );
      final reset = DailyRewardPolicy.decide(
        isCorrect: true,
        today: '2026-07-21',
        yesterday: '2026-07-20',
        lastAnsweredDate: '2026-07-18',
        currentStreak: 4,
        currentBestStreak: 7,
        currentTotalAnswered: 10,
        currentTotalCorrect: 8,
      );

      expect(continued.streak, 5);
      expect(continued.bestStreak, 5);
      expect(reset.streak, 1);
      expect(reset.bestStreak, 7);
    });
  });
}
