import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/services/logger_service.dart';

/// Service to manage mission progress persistence
class MissionProgressService {
  static const String _keyPrefix = 'mission_completed_';

  /// Check if a mission is completed
  Future<bool> isMissionCompleted(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_keyPrefix$missionId') ?? false;
  }

  /// Mark a mission as completed
  Future<void> completeMission(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_keyPrefix$missionId', true);
    AppLogger.success('Mission completed: $missionId');
  }

  /// Get all completed missions for a category
  Future<Map<String, bool>> getCategoryProgress(List<String> missionIds) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, bool> progress = {};

    for (final missionId in missionIds) {
      progress[missionId] = prefs.getBool('$_keyPrefix$missionId') ?? false;
    }

    return progress;
  }

  /// Reset progress for a specific mission (for testing)
  Future<void> resetMission(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$missionId');
    AppLogger.refresh('Mission reset: $missionId');
  }

  /// Reset all progress (for testing)
  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
    AppLogger.refresh('All mission progress reset');
  }
}
