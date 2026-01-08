import '../entities/mission_category.dart';
import '../../data/repositories/missions_repository.dart';

/// UseCase for getting mission categories.
///
/// Uses MissionsRepository which implements:
/// 1. Remote-first (Firebase)
/// 2. Cache fallback
/// 3. Hardcoded fallback
class GetMissionCategories {
  final MissionsRepository _repository;

  GetMissionCategories({MissionsRepository? repository})
    : _repository = repository ?? MissionsRepository();

  /// Execute the use case to get mission categories
  Future<List<MissionCategory>> execute(String userId) async {
    try {
      final categories = await _repository.getMissionCategories(userId);
      print('✅ Misiones cargadas (${categories.length} categorías)');
      return categories;
    } catch (e) {
      print('⚠️ Error cargando misiones: $e');
      return [];
    }
  }

  /// Mark a mission as completed
  Future<void> completeMission(String userId, String missionId) async {
    try {
      await _repository.completeMission(userId, missionId);
      print('✅ Misión $missionId completada');
    } catch (e) {
      print('⚠️ Error completando misión: $e');
    }
  }

  /// Legacy save method - kept for backwards compatibility
  /// Note: With the new structure, categories are fetched from global collections
  /// and only user progress needs to be saved
  @Deprecated('Use completeMission instead for saving progress')
  Future<void> save(String userId, List<MissionCategory> categories) async {
    // This method is now a no-op since categories come from global collections
    // User progress is saved via completeMission
    print('ℹ️ save() called but no longer needed - categories are global');
  }
}
