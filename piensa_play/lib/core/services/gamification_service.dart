import 'package:cloud_firestore/cloud_firestore.dart';
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      // 1. Cargar achievement actual
      var achievement = await _loadAchievement(userId);

      // 2. Agregar XP y monedas por misión
      final newTotalXP = achievement.totalXP + GamificationConfig.xpPerMission;
      final newCoins = achievement.coins + GamificationConfig.coinsPerMission;
      final newLevel = Achievement.calculateLevel(newTotalXP);

      achievement = achievement.copyWith(
        totalXP: newTotalXP,
        coins: newCoins,
        currentLevel: newLevel,
      );

      AppLogger.log(
        'GAMIFICATION: +${GamificationConfig.xpPerMission} XP, +${GamificationConfig.coinsPerMission} coins',
      );
      AppLogger.log('GAMIFICATION: Total XP: $newTotalXP, Level: $newLevel');

      // 3. Desbloquear badge de la misión
      final missionBadge = await _unlockBadge(userId, 'mission_${mission.id}');
      if (missionBadge != null) {
        unlockedBadges.add(missionBadge);
      }

      // 4. Verificar si la categoría está completa
      final isCategoryComplete = await _checkCategoryComplete(userId, category);
      if (isCategoryComplete) {
        AppLogger.success(
          'GAMIFICATION: Category ${category.id} complete! +${GamificationConfig.xpPerCategory} XP bonus',
        );

        // Bonus XP por categoría completa
        final categoryBonusXP =
            achievement.totalXP + GamificationConfig.xpPerCategory;
        achievement = achievement.copyWith(
          totalXP: categoryBonusXP,
          currentLevel: Achievement.calculateLevel(categoryBonusXP),
        );

        // Desbloquear badge de categoría
        final categoryBadge = await _unlockBadge(
          userId,
          'category_${category.id}',
        );
        if (categoryBadge != null) {
          unlockedBadges.add(categoryBadge);
        }
      }

      // 5. Guardar progreso
      await _saveAchievement(userId, achievement);
      await _saveMissionProgress(userId, mission.id);

      AppLogger.success(
        'GAMIFICATION: Unlocked ${unlockedBadges.length} badges',
      );
      return unlockedBadges;
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error completing mission: $e');
      return [];
    }
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

  /// Guarda el achievement en Firebase y cache local
  Future<void> _saveAchievement(String userId, Achievement achievement) async {
    try {
      // Guardar en Firebase
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .set({
            ...achievement.toJson(),
            'lastUpdated': FieldValue.serverTimestamp(),
          });

      // Guardar en cache local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('achievements', jsonEncode(achievement.toJson()));

      // Actualizar caché de AppDataService para sincronizar UI inmediatamente
      AppDataService.instance.updateAchievement(achievement);

      AppLogger.success('GAMIFICATION: Achievement saved');
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error saving achievement: $e');
    }
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

      // Desbloquear
      await badgeRef.set({'unlockedAt': FieldValue.serverTimestamp()});

      final data = globalBadge.data()!;
      final badge = entities.Badge(
        id: badgeId,
        title: data['title'] ?? '',
        description: data['description'],
        iconName: data['iconName'] ?? '',
        isUnlocked: true,
      );

      AppLogger.success('GAMIFICATION: Badge unlocked: ${badge.title}');
      return badge;
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error unlocking badge: $e');
      return null;
    }
  }

  /// Verifica si todas las misiones de una categoría están completas
  Future<bool> _checkCategoryComplete(
    String userId,
    MissionCategory category,
  ) async {
    try {
      final progressSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mission_progress')
          .get();

      final completedMissionIds = progressSnapshot.docs
          .where((doc) => doc.data()['isCompleted'] == true)
          .map((doc) => doc.id)
          .toSet();

      final categoryMissionIds = category.missions.map((m) => m.id).toSet();

      return categoryMissionIds.every((id) => completedMissionIds.contains(id));
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error checking category completion: $e');
      return false;
    }
  }

  /// Guarda el progreso de una misión como completada
  Future<void> _saveMissionProgress(String userId, String missionId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('mission_progress')
          .doc(missionId)
          .set({
            'isCompleted': true,
            'completedAt': FieldValue.serverTimestamp(),
          });

      // Actualizar caché para que el mapa refleje el cambio inmediatamente
      AppDataService.instance.markMissionCompleted(missionId);
    } catch (e) {
      AppLogger.error('GAMIFICATION: Error saving mission progress: $e');
    }
  }

  /// Obtiene el achievement actual (para UI)
  Future<Achievement> getAchievement() async {
    final userId = UserIdProvider.currentUserId;
    return _loadAchievement(userId);
  }
}
