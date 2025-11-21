import '../entities/mission_category.dart';
import '../../data/datasources/missions_local_datasource.dart';
import '../../data/datasources/missions_remote_datasource.dart';

class GetMissionCategories {
  final MissionsLocalDatasource _localDatasource = MissionsLocalDatasource();
  final MissionsRemoteDatasource _remoteDatasource = MissionsRemoteDatasource();

  Future<List<MissionCategory>> execute(String userId) async {
    try {
      // Intenta obtener de local primero
      final categories = await _localDatasource.getMissionCategories(userId);
      print('✅ Misiones cargadas desde local');
      return categories;
    } catch (e) {
      print('⚠️ Error cargando misiones locales: $e');
      return [];
    }
  }

  Future<void> save(String userId, List<MissionCategory> categories) async {
    try {
      await _remoteDatasource.saveMissionCategories(userId, categories);
      print('✅ Misiones guardadas en Firestore');
    } catch (e) {
      print('⚠️ Error guardando misiones: $e');
    }
  }
}
