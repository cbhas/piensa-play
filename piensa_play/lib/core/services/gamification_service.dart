import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/firestore_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import '../../features/achievements/domain/entities/achievement.dart';
import '../../features/achievements/domain/entities/badge.dart' as entities;
import '../../features/missions/domain/entities/mission.dart';
import '../../features/missions/domain/entities/mission_category.dart';
import 'user_id_provider.dart';

/// Servicio centralizado para manejar la gamificación:
/// - XP y niveles
/// - Monedas
/// - Desbloqueo de badges
class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final FirebaseFirestore _firestore = FirestoreProvider.instance;

  /// Llamar cuando el usuario completa una misión
  /// Retorna los badges desbloqueados (para mostrar animación)
  Future<List<entities.Badge>> completeMission({
    required Mission mission,
    required MissionCategory category,
  }) async {
    final userId = UserIdProvider.currentUserId;
    final unlockedBadges = <entities.Badge>[];

    AppLogger.log('GAMIFICATION: Completing mission ${mission.id}');

    try {
      // 0. Guarda de idempotencia: si la misión YA estaba completada, no se
      //    vuelven a otorgar XP/monedas (evita inflación al rejugar). Se lee de
      //    la caché en memoria, que funciona offline.
      final alreadyCompleted = _isMissionCompletedInCache(mission.id);

      // 1. Cargar achievement actual (lectura: offline-ok vía caché de Firestore)
      var achievement = await _loadAchievement(userId);

      if (alreadyCompleted) {
        AppLogger.log(
          'GAMIFICATION: Mission ${mission.id} ya completada, sin recompensas',
        );
      } else {
        // 2. Agregar XP y monedas por misión
        final newTotalXP =
            achievement.totalXP + GamificationConfig.xpPerMission;
        final newCoins = achievement.coins + GamificationConfig.coinsPerMission;
        achievement = achievement.copyWith(
          totalXP: newTotalXP,
          coins: newCoins,
          currentLevel: Achievement.calculateLevel(newTotalXP),
        );
        AppLogger.log(
          'GAMIFICATION: +${GamificationConfig.xpPerMission} XP, +${GamificationConfig.coinsPerMission} coins (Total: $newTotalXP)',
        );
      }

      // 3. Marcar la misión como completada en la fuente única (caché en memoria
      //    al instante + Firestore en segundo plano). Se hace ANTES de evaluar la
      //    categoría para que la misión actual cuente en el cálculo.
      AppDataService.instance.markMissionCompleted(mission.id);
      _saveMissionProgress(userId, mission.id); // no bloqueante (offline-first)

      // 4. Desbloquear badge de la misión (idempotente)
      final missionBadge = await _unlockBadge(userId, 'mission_${mission.id}');
      if (missionBadge != null) {
        unlockedBadges.add(missionBadge);
      }

      // 5. ¿Categoría completa? Se calcula desde la caché (ya incluye la misión
      //    recién marcada). Solo otorga el bonus la primera vez.
      if (!alreadyCompleted && _isCategoryCompleteInCache(category.id)) {
        AppLogger.success(
          'GAMIFICATION: Category ${category.id} complete! +${GamificationConfig.xpPerCategory} XP bonus',
        );

        final categoryBonusXP =
            achievement.totalXP + GamificationConfig.xpPerCategory;
        achievement = achievement.copyWith(
          totalXP: categoryBonusXP,
          currentLevel: Achievement.calculateLevel(categoryBonusXP),
        );

        final categoryBadge = await _unlockBadge(
          userId,
          'category_${category.id}',
        );
        if (categoryBadge != null) {
          unlockedBadges.add(categoryBadge);
        }
      }

      // 6. Guardar achievement (caché al instante + Firestore en segundo plano)
      if (!alreadyCompleted) {
        _saveAchievement(userId, achievement);
      }

      AppLogger.success(
        'GAMIFICATION: Unlocked ${unlockedBadges.length} badges',
      );
      return unlockedBadges;
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error completing mission: $e');
      return [];
    }
  }

  /// Indica si una misión ya está marcada como completada en la caché en memoria.
  bool _isMissionCompletedInCache(String missionId) {
    for (final category in AppDataService.instance.missionCategories) {
      for (final mission in category.missions) {
        if (mission.id == missionId) return mission.isCompleted;
      }
    }
    return false;
  }

  /// Indica si todas las misiones de una categoría están completas según la
  /// caché en memoria (fuente única, offline-ok).
  bool _isCategoryCompleteInCache(String categoryId) {
    final match = AppDataService.instance.missionCategories
        .where((c) => c.id == categoryId);
    if (match.isEmpty) return false;
    final missions = match.first.missions;
    if (missions.isEmpty) return false;
    return missions.every((m) => m.isCompleted);
  }

  /// Carga el achievement actual del usuario
  Future<Achievement> _loadAchievement(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .get();

      if (doc.exists) {
        return Achievement.fromJson(doc.data()!);
      }
    } catch (e) {
      AppLogger.warning('GAMIFICATION: Error loading achievement: $e');
    }

    // Fallback: intentar desde cache local
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

  /// Guarda el achievement (offline-first: caché al instante, persistencia en
  /// segundo plano). NO se hace `await` de la escritura remota porque, con la
  /// persistencia de Firestore activada, ese Future no se resuelve mientras se
  /// está offline; la escritura queda en cola local y se sincroniza sola al
  /// reconectar.
  void _saveAchievement(String userId, Achievement achievement) {
    // 1. Caché en memoria primero -> UI inmediata, online u offline
    AppDataService.instance.updateAchievement(achievement);

    // 2. Persistencia remota (en segundo plano, se sincroniza al reconectar)
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

    // 3. Respaldo local de arranque (en segundo plano)
    SharedPreferences.getInstance()
        .then((prefs) {
          prefs.setString('achievements', jsonEncode(achievement.toJson()));
        })
        .catchError((e) {
          AppLogger.warning('GAMIFICATION: Error caching achievement: $e');
        });
  }

  /// Desbloquea un badge y lo retorna si es nuevo
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
        return null; // Ya desbloqueado
      }

      // Obtener info del badge desde catálogo global
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

      // Desbloquear (persistencia en segundo plano: se sincroniza al
      // reconectar, sin bloquear el flujo offline).
      badgeRef.set({'unlockedAt': FieldValue.serverTimestamp()}).catchError((e) {
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

      // Sincronizar la caché de logros para que la UI refleje el badge
      // sin esperar a una recarga completa de la app.
      AppDataService.instance.unlockBadge(badgeId);

      AppLogger.success('GAMIFICATION: Badge unlocked: ${badge.title}');
      return badge;
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error unlocking badge: $e');
      return null;
    }
  }

  /// Guarda el progreso de una misión como completada (offline-first).
  /// La caché en memoria ya la actualiza el llamador con [markMissionCompleted];
  /// aquí solo se persiste a Firestore en segundo plano (se sincroniza al
  /// reconectar, sin bloquear la UI).
  void _saveMissionProgress(String userId, String missionId) {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('mission_progress')
        .doc(missionId)
        .set({'isCompleted': true, 'completedAt': FieldValue.serverTimestamp()})
        .catchError((e) {
          AppLogger.error('GAMIFICATION: Error saving mission progress: $e');
        });
  }

  /// Obtiene el achievement actual (para UI)
  Future<Achievement> getAchievement() async {
    final userId = UserIdProvider.currentUserId;
    return _loadAchievement(userId);
  }
}
