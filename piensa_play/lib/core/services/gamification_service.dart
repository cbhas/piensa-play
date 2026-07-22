import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/reward_policy.dart';
import '../../features/achievements/domain/entities/achievement.dart';
import '../../features/achievements/domain/entities/badge.dart' as entities;
import '../../features/missions/domain/entities/mission.dart';
import '../../features/missions/domain/entities/mission_category.dart';
import 'app_data_service.dart';
import 'logger_service.dart';
import 'user_id_provider.dart';

/// Resultado idempotente de completar una mision.
class MissionRewardResult {
  final bool wasFirstCompletion;
  final bool categoryCompletedNow;
  final int xpAwarded;
  final int coinsAwarded;
  final List<entities.Badge> unlockedBadges;

  const MissionRewardResult({
    required this.wasFirstCompletion,
    required this.categoryCompletedNow,
    required this.xpAwarded,
    required this.coinsAwarded,
    required this.unlockedBadges,
  });
}

/// Unico punto de escritura para progreso, XP, monedas e insignias.
///
/// Las recompensas se reclaman dentro de una transaccion de Firestore. Repetir
/// una mision nunca vuelve a entregar XP, monedas o el bono de categoria.
class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MissionRewardResult? _lastResult;

  MissionRewardResult? get lastResult => _lastResult;

  /// Mantiene la firma historica para no romper las pantallas existentes.
  Future<List<entities.Badge>> completeMission({
    required Mission mission,
    required MissionCategory category,
  }) async {
    final result = await completeMissionWithResult(
      mission: mission,
      category: category,
    );
    return result.unlockedBadges;
  }

  Future<MissionRewardResult> completeMissionWithResult({
    required Mission mission,
    required MissionCategory category,
  }) async {
    final userId = UserIdProvider.currentUserId;
    final userRef = _firestore.collection('users').doc(userId);
    final achievementRef = userRef.collection('achievements').doc('current');
    final missionRef = userRef.collection('mission_progress').doc(mission.id);
    final categoryClaimRef = userRef
        .collection('reward_claims')
        .doc('category_${category.id}');

    var firstCompletion = false;
    var categoryCompletedNow = false;
    var updatedAchievement = Achievement.initial();
    final awardedBadgeIds = <String>[];

    try {
      await _firestore.runTransaction((transaction) async {
        // Firestore exige realizar todas las lecturas antes de escribir.
        final missionSnapshot = await transaction.get(missionRef);
        final achievementSnapshot = await transaction.get(achievementRef);
        final categoryClaimSnapshot = await transaction.get(categoryClaimRef);

        final progressSnapshots = <String, DocumentSnapshot>{};
        for (final item in category.missions) {
          if (item.id == mission.id) continue;
          progressSnapshots[item.id] = await transaction.get(
            userRef.collection('mission_progress').doc(item.id),
          );
        }

        updatedAchievement = achievementSnapshot.exists
            ? Achievement.fromJson(
                achievementSnapshot.data() as Map<String, dynamic>,
              )
            : Achievement.initial();

        final alreadyCompleted =
            missionSnapshot.exists &&
            (missionSnapshot.data()?['isCompleted'] == true);

        final allOtherMissionsComplete = category.missions
            .where((item) => item.id != mission.id)
            .every((item) {
              final data = progressSnapshots[item.id]?.data();
              return data is Map<String, dynamic> &&
                  data['isCompleted'] == true;
            });

        final decision = MissionRewardPolicy.decide(
          missionAlreadyCompleted: alreadyCompleted,
          allOtherMissionsCompleted: allOtherMissionsComplete,
          categoryBonusAlreadyClaimed: categoryClaimSnapshot.exists,
        );
        if (!decision.grantMissionReward) return;

        firstCompletion = true;
        if (decision.grantCategoryBonus) {
          categoryCompletedNow = true;
          transaction.set(categoryClaimRef, {
            'categoryId': category.id,
            'claimedAt': FieldValue.serverTimestamp(),
          });
          awardedBadgeIds.add('category_${category.id}');
        }

        final totalXP = updatedAchievement.totalXP + decision.xp;
        updatedAchievement = updatedAchievement.copyWith(
          totalXP: totalXP,
          coins: updatedAchievement.coins + decision.coins,
          currentLevel: Achievement.calculateLevel(totalXP),
        );

        transaction.set(missionRef, {
          'isCompleted': true,
          'rewardGranted': true,
          'completedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        transaction.set(achievementRef, {
          ...updatedAchievement.toJson(),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        final missionBadgeId = 'mission_${mission.id}';
        awardedBadgeIds.add(missionBadgeId);
        for (final badgeId in awardedBadgeIds) {
          transaction.set(
            userRef.collection('unlockedBadges').doc(badgeId),
            {'unlockedAt': FieldValue.serverTimestamp()},
            SetOptions(merge: true),
          );
        }
      });

      if (!firstCompletion) {
        final result = MissionRewardResult(
          wasFirstCompletion: false,
          categoryCompletedNow: false,
          xpAwarded: 0,
          coinsAwarded: 0,
          unlockedBadges: const [],
        );
        _lastResult = result;
        return result;
      }

      await _persistLocalAchievement(updatedAchievement);
      AppDataService.instance.updateAchievement(updatedAchievement);
      AppDataService.instance.markMissionCompleted(mission.id);

      final badges = await _loadBadgeDetails(awardedBadgeIds);
      final result = MissionRewardResult(
        wasFirstCompletion: true,
        categoryCompletedNow: categoryCompletedNow,
        xpAwarded:
            GamificationConfig.xpPerMission +
            (categoryCompletedNow ? GamificationConfig.xpPerCategory : 0),
        coinsAwarded: GamificationConfig.coinsPerMission,
        unlockedBadges: badges,
      );
      _lastResult = result;
      return result;
    } catch (error) {
      AppLogger.error('GAMIFICATION: atomic completion failed: $error');
      rethrow;
    }
  }

  Future<List<entities.Badge>> _loadBadgeDetails(List<String> ids) async {
    final badges = <entities.Badge>[];
    for (final id in ids) {
      try {
        final snapshot = await _firestore.collection('badges').doc(id).get();
        if (!snapshot.exists) continue;
        final data = snapshot.data()!;
        badges.add(
          entities.Badge(
            id: id,
            title: data['title'] ?? '',
            description: data['description'],
            iconName: data['iconName'] ?? '',
            isUnlocked: true,
          ),
        );
      } catch (error) {
        AppLogger.warning('GAMIFICATION: badge $id unavailable: $error');
      }
    }
    return badges;
  }

  Future<void> _persistLocalAchievement(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('achievements', jsonEncode(achievement.toJson()));
  }

  Future<Achievement> getAchievement() async {
    final userId = UserIdProvider.currentUserId;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .get();
      if (snapshot.exists) return Achievement.fromJson(snapshot.data()!);
    } catch (error) {
      AppLogger.warning('GAMIFICATION: using local achievement: $error');
    }

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('achievements');
    if (cached != null) {
      return Achievement.fromJson(jsonDecode(cached));
    }
    return Achievement.initial();
  }
}
