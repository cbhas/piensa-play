import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/badge.dart';
import '../../domain/entities/recent_activity.dart';
import '../datasources/achievements_local_datasource.dart';
import '../datasources/achievements_remote_datasource.dart';

class AchievementsRepositoryImpl {
  final AchievementsLocalDatasource localDatasource =
      AchievementsLocalDatasource();
  final AchievementsRemoteDatasource remoteDatasource =
      AchievementsRemoteDatasource();

  // Obtener Achievement (primero remoto, si falla local)
  Future<Achievement> getAchievements(String userId) async {
    try {
      final remote = await remoteDatasource.getAchievements(userId);
      if (remote != null) {
        await localDatasource.saveAchievements(remote);
        return remote;
      }
    } catch (e) {
      AppLogger.warning('Firestore falló, usando caché local: $e');
    }
    return await localDatasource.getAchievements();
  }

  // Guardar Achievement (local + remoto)
  Future<void> saveAchievements(String userId, Achievement achievement) async {
    await localDatasource.saveAchievements(achievement);
    try {
      await remoteDatasource.saveAchievements(userId, achievement);
    } catch (e) {
      AppLogger.warning(
        'Error sincronizando con Firestore, pero guardado localmente: $e',
      );
    }
  }

  // Obtener Badges (primero remoto, si falla local)
  Future<List<Badge>> getBadges(String userId) async {
    try {
      final remote = await remoteDatasource.getBadges(userId);
      if (remote != null) {
        await localDatasource.saveBadges(remote);
        return remote;
      }
    } catch (e) {
      AppLogger.warning('Firestore falló, usando caché local: $e');
    }
    return await localDatasource.getBadges();
  }

  // Guardar Badges (local + remoto)
  Future<void> saveBadges(String userId, List<Badge> badges) async {
    await localDatasource.saveBadges(badges);
    try {
      await remoteDatasource.saveBadges(userId, badges);
    } catch (e) {
      AppLogger.warning(
        'Error sincronizando con Firestore, pero guardado localmente: $e',
      );
    }
  }

  // Obtener Recent Activities (primero remoto, si falla local)
  Future<List<RecentActivity>> getRecentActivities(String userId) async {
    try {
      final remote = await remoteDatasource.getRecentActivities(userId);
      if (remote != null) {
        await localDatasource.saveRecentActivities(remote);
        return remote;
      }
    } catch (e) {
      AppLogger.warning('Firestore falló, usando caché local: $e');
    }
    return await localDatasource.getRecentActivities();
  }

  // Guardar Recent Activities (local + remoto)
  Future<void> saveRecentActivities(
    String userId,
    List<RecentActivity> activities,
  ) async {
    await localDatasource.saveRecentActivities(activities);
    try {
      await remoteDatasource.saveRecentActivities(userId, activities);
    } catch (e) {
      AppLogger.warning(
        'Error sincronizando con Firestore, pero guardado localmente: $e',
      );
    }
  }
}
