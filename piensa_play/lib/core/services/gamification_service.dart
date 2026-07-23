import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/reward_policy.dart';
import '../../features/achievements/domain/entities/achievement.dart';
import '../../features/achievements/domain/entities/badge.dart' as entities;
import '../../features/missions/domain/entities/mission.dart';
import '../../features/missions/domain/entities/mission_category.dart';
import 'app_data_service.dart';
import 'connectivity_service.dart';
import 'firestore_provider.dart';
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

  static const empty = MissionRewardResult(
    wasFirstCompletion: false,
    categoryCompletedNow: false,
    xpAwarded: 0,
    coinsAwarded: 0,
    unlockedBadges: [],
  );
}

/// Unico punto de escritura para progreso, XP, monedas e insignias.
///
/// Hay dos caminos para reclamar recompensas y ambos son idempotentes:
///
/// * **Atomico (con red):** una transaccion de Firestore lee el progreso, el
///   achievement y el registro de bonus de categoria, y escribe todo junto.
///   Es a prueba de carreras entre dispositivos.
/// * **Optimista (sin red):** `runTransaction` NO funciona offline — a
///   diferencia de `set()`/`update()`, que se encolan en la persistencia local,
///   una transaccion necesita ida y vuelta al servidor y falla sin conexion.
///   En ese caso se actualiza la cache en memoria al instante y las escrituras
///   quedan encoladas; Firestore las sincroniza al reconectar.
///
/// La idempotencia sobrevive al cambio de camino porque ambos marcan los mismos
/// documentos: `mission_progress/{id}.rewardGranted` y
/// `reward_claims/category_{id}`. Una transaccion posterior los ve y no vuelve
/// a otorgar nada.
class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final FirebaseFirestore _firestore = FirestoreProvider.instance;
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

  /// Completa una mision y reclama sus recompensas una sola vez.
  ///
  /// Nunca lanza: si ambos caminos fallan devuelve [MissionRewardResult.empty]
  /// para que la pantalla de resultados no se rompa.
  Future<MissionRewardResult> completeMissionWithResult({
    required Mission mission,
    required MissionCategory category,
  }) async {
    if (ConnectivityService.instance.isOnline) {
      try {
        final result = await _completeAtomically(mission, category);
        _lastResult = result;
        return result;
      } catch (error) {
        // Sin red real (o transaccion agotada): se sigue por el camino
        // optimista en vez de dejar al usuario sin recompensa.
        AppLogger.warning(
          'GAMIFICATION: transaccion no disponible, usando camino offline: $error',
        );
      }
    }

    final result = await _completeOptimistically(mission, category);
    _lastResult = result;
    return result;
  }

  // ---------------------------------------------------------------------------
  // Camino atomico (requiere conexion)
  // ---------------------------------------------------------------------------

  Future<MissionRewardResult> _completeAtomically(
    Mission mission,
    MissionCategory category,
  ) async {
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
            return data is Map<String, dynamic> && data['isCompleted'] == true;
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

    // La mision ya estaba completada: se refleja en cache igualmente para que
    // el mapa la muestre completa aunque la cache viniera fria.
    AppDataService.instance.markMissionCompleted(mission.id);

    if (!firstCompletion) return MissionRewardResult.empty;

    await _persistLocalAchievement(updatedAchievement);
    AppDataService.instance.updateAchievement(updatedAchievement);
    for (final badgeId in awardedBadgeIds) {
      AppDataService.instance.unlockBadge(badgeId);
    }

    final badges = await _loadBadgeDetails(awardedBadgeIds);
    return MissionRewardResult(
      wasFirstCompletion: true,
      categoryCompletedNow: categoryCompletedNow,
      xpAwarded:
          GamificationConfig.xpPerMission +
          (categoryCompletedNow ? GamificationConfig.xpPerCategory : 0),
      coinsAwarded: GamificationConfig.coinsPerMission,
      unlockedBadges: badges,
    );
  }

  // ---------------------------------------------------------------------------
  // Camino optimista (funciona sin conexion)
  // ---------------------------------------------------------------------------

  Future<MissionRewardResult> _completeOptimistically(
    Mission mission,
    MissionCategory category,
  ) async {
    final userId = UserIdProvider.currentUserId;
    final unlockedBadges = <entities.Badge>[];

    AppLogger.log('GAMIFICATION: Completing mission ${mission.id} (offline)');

    try {
      // 0. Guarda de idempotencia: rejugar no vuelve a otorgar XP/monedas.
      final alreadyCompleted = await _isMissionAlreadyCompleted(
        userId,
        mission.id,
      );

      var achievement = await _loadAchievement(userId);
      var categoryCompletedNow = false;
      var xpAwarded = 0;
      var coinsAwarded = 0;

      if (!alreadyCompleted) {
        final newTotalXP = achievement.totalXP + GamificationConfig.xpPerMission;
        achievement = achievement.copyWith(
          totalXP: newTotalXP,
          coins: achievement.coins + GamificationConfig.coinsPerMission,
          currentLevel: Achievement.calculateLevel(newTotalXP),
        );
        xpAwarded = GamificationConfig.xpPerMission;
        coinsAwarded = GamificationConfig.coinsPerMission;
      }

      // 1. Marcar la mision en la fuente unica (cache al instante + Firestore
      //    encolado). Se hace ANTES de evaluar la categoria para que la mision
      //    actual cuente en el calculo.
      AppDataService.instance.markMissionCompleted(mission.id);
      _saveMissionProgress(userId, mission.id);

      // 2. Badge de la mision (idempotente).
      final missionBadge = await _unlockBadge(userId, 'mission_${mission.id}');
      if (missionBadge != null) unlockedBadges.add(missionBadge);

      // 3. Bonus de categoria: solo la primera vez y solo si no se reclamo ya.
      if (!alreadyCompleted &&
          _isCategoryCompleteInCache(category.id) &&
          !await _isCategoryBonusClaimed(userId, category.id)) {
        categoryCompletedNow = true;
        final bonusXP = achievement.totalXP + GamificationConfig.xpPerCategory;
        achievement = achievement.copyWith(
          totalXP: bonusXP,
          currentLevel: Achievement.calculateLevel(bonusXP),
        );
        xpAwarded += GamificationConfig.xpPerCategory;

        // Marca de reclamo: la transaccion la vera al reconectar y no volvera
        // a otorgar el bonus.
        _claimCategoryBonus(userId, category.id);

        final categoryBadge = await _unlockBadge(
          userId,
          'category_${category.id}',
        );
        if (categoryBadge != null) unlockedBadges.add(categoryBadge);
      }

      if (!alreadyCompleted) {
        _saveAchievement(userId, achievement);
      }

      return MissionRewardResult(
        wasFirstCompletion: !alreadyCompleted,
        categoryCompletedNow: categoryCompletedNow,
        xpAwarded: xpAwarded,
        coinsAwarded: coinsAwarded,
        unlockedBadges: unlockedBadges,
      );
    } catch (error) {
      AppLogger.error('GAMIFICATION: Error completing mission: $error');
      return MissionRewardResult.empty;
    }
  }

  // ---------------------------------------------------------------------------
  // Lecturas
  // ---------------------------------------------------------------------------

  /// Indica si una mision ya esta completada. Prefiere la cache en memoria
  /// (instantanea, offline-ok); si la cache no se cargo (p. ej. el splash fallo
  /// sin conexion) cae a Firestore, cuya lectura offline usa la persistencia
  /// local. Asi evita otorgar XP/monedas dos veces al rejugar incluso si la
  /// cache esta vacia.
  Future<bool> _isMissionAlreadyCompleted(
    String userId,
    String missionId,
  ) async {
    final categories = AppDataService.instance.missionCategories;
    if (categories.isNotEmpty) {
      for (final category in categories) {
        for (final mission in category.missions) {
          if (mission.id == missionId) return mission.isCompleted;
        }
      }
    }
    // Cache vacia: verificar en Firestore (offline lee de la persistencia).
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mission_progress')
          .doc(missionId)
          .get();
      return doc.exists && (doc.data()?['isCompleted'] == true);
    } catch (_) {
      return false;
    }
  }

  /// Indica si todas las misiones de una categoria estan completas segun la
  /// cache en memoria (fuente unica, offline-ok).
  bool _isCategoryCompleteInCache(String categoryId) {
    final match = AppDataService.instance.missionCategories.where(
      (c) => c.id == categoryId,
    );
    if (match.isEmpty) return false;
    final missions = match.first.missions;
    if (missions.isEmpty) return false;
    return missions.every((m) => m.isCompleted);
  }

  Future<bool> _isCategoryBonusClaimed(String userId, String categoryId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('reward_claims')
          .doc('category_$categoryId')
          .get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  /// Carga el achievement actual del usuario.
  Future<Achievement> _loadAchievement(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .get();

      if (doc.exists) return Achievement.fromJson(doc.data()!);
    } catch (e) {
      AppLogger.warning('GAMIFICATION: Error loading achievement: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('achievements');
      if (jsonString != null) {
        return Achievement.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      AppLogger.warning('GAMIFICATION: Error loading from cache: $e');
    }

    return Achievement.initial();
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

  /// Obtiene el achievement actual (para UI).
  Future<Achievement> getAchievement() async {
    return _loadAchievement(UserIdProvider.currentUserId);
  }

  // ---------------------------------------------------------------------------
  // Escrituras no bloqueantes
  //
  // NO se hace `await` de estas escrituras: con la persistencia de Firestore
  // activada, el Future no se resuelve mientras se esta offline. La escritura
  // queda en cola local y se sincroniza sola al reconectar.
  // ---------------------------------------------------------------------------

  void _saveAchievement(String userId, Achievement achievement) {
    // 1. Cache en memoria primero -> UI inmediata, online u offline.
    AppDataService.instance.updateAchievement(achievement);

    // 2. Persistencia remota (en segundo plano).
    _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .doc('current')
        .set({
          ...achievement.toJson(),
          'lastUpdated': FieldValue.serverTimestamp(),
        })
        .catchError((e) {
          AppLogger.error('GAMIFICATION: Error saving achievement: $e');
        });

    // 3. Respaldo local de arranque (en segundo plano).
    _persistLocalAchievement(achievement).catchError((e) {
      AppLogger.warning('GAMIFICATION: Error caching achievement: $e');
    });
  }

  Future<void> _persistLocalAchievement(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('achievements', jsonEncode(achievement.toJson()));
  }

  void _saveMissionProgress(String userId, String missionId) {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('mission_progress')
        .doc(missionId)
        .set({
          'isCompleted': true,
          'rewardGranted': true,
          'completedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true))
        .catchError((e) {
          AppLogger.error('GAMIFICATION: Error saving mission progress: $e');
        });
  }

  void _claimCategoryBonus(String userId, String categoryId) {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('reward_claims')
        .doc('category_$categoryId')
        .set({
          'categoryId': categoryId,
          'claimedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true))
        .catchError((e) {
          AppLogger.error('GAMIFICATION: Error claiming category bonus: $e');
        });
  }

  /// Desbloquea un badge y lo retorna si es nuevo.
  Future<entities.Badge?> _unlockBadge(String userId, String badgeId) async {
    try {
      final badgeRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('unlockedBadges')
          .doc(badgeId);

      final existing = await badgeRef.get();
      if (existing.exists) {
        AppLogger.log('GAMIFICATION: Badge $badgeId already unlocked');
        return null;
      }

      final globalBadge = await _firestore
          .collection('badges')
          .doc(badgeId)
          .get();

      if (!globalBadge.exists) {
        AppLogger.warning(
          'GAMIFICATION: Badge $badgeId not found in global catalog',
        );
        return null;
      }

      // Persistencia en segundo plano: se sincroniza al reconectar.
      badgeRef.set({'unlockedAt': FieldValue.serverTimestamp()}).catchError((
        e,
      ) {
        AppLogger.error('GAMIFICATION: Error persisting badge $badgeId: $e');
      });

      final data = globalBadge.data()!;
      final badge = entities.Badge(
        id: badgeId,
        title: data['title'] ?? '',
        description: data['description'],
        iconName: data['iconName'] ?? '',
        isUnlocked: true,
      );

      // Sincronizar la cache de logros para que la UI refleje el badge sin
      // esperar a una recarga completa de la app.
      AppDataService.instance.unlockBadge(badgeId);

      AppLogger.success('GAMIFICATION: Badge unlocked: ${badge.title}');
      return badge;
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error unlocking badge: $e');
      return null;
    }
  }
}
