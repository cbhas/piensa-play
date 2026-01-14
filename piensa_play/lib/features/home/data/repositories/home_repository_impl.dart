// lib/features/home/data/repositories/home_repository_impl.dart

import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/user_progress.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl {
  final HomeLocalDatasource localDatasource = HomeLocalDatasource();
  final HomeRemoteDatasource remoteDatasource = HomeRemoteDatasource();

  // Obtener DashboardStats (primero remoto, si falla local)
  Future<DashboardStats> getDashboardStats(String userId) async {
    try {
      final remoteStats = await remoteDatasource.getDashboardStats(userId);
      if (remoteStats != null) {
        await localDatasource.saveDashboardStats(remoteStats);
        return remoteStats;
      }
    } catch (e) {
      AppLogger.warning('Firestore falló, usando caché local: $e');
    }
    return await localDatasource.getDashboardStats();
  }

  // Obtener UserProgress (primero remoto, si falla local)
  Future<UserProgress> getUserProgress(String userId) async {
    try {
      final remoteProgress = await remoteDatasource.getUserProgress(userId);
      if (remoteProgress != null) {
        await localDatasource.saveUserProgress(remoteProgress);
        return remoteProgress;
      }
    } catch (e) {
      AppLogger.warning('Firestore falló, usando caché local: $e');
    }
    return await localDatasource.getUserProgress();
  }

  // Guardar DashboardStats (guardas local + remoto)
  Future<void> saveDashboardStats(String userId, DashboardStats stats) async {
    await localDatasource.saveDashboardStats(stats);
    try {
      await remoteDatasource.saveDashboardStats(userId, stats);
    } catch (e) {
      AppLogger.warning(
        'Error sincronizando con Firestore, pero guardado localmente: $e',
      );
    }
  }

  // Guardar UserProgress (guardas local + remoto)
  Future<void> saveUserProgress(String userId, UserProgress progress) async {
    await localDatasource.saveUserProgress(progress);
    try {
      await remoteDatasource.saveUserProgress(userId, progress);
    } catch (e) {
      AppLogger.warning(
        'Error sincronizando con Firestore, pero guardado localmente: $e',
      );
    }
  }
}
