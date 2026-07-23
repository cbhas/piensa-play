import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_data_service.dart';
import 'logger_service.dart';
import 'user_id_provider.dart';

/// Firestore es la fuente de verdad; SharedPreferences es su espejo offline.
class MissionProgressService {
  static const _keyPrefix = 'mission_completed_';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isMissionCompleted(String missionId) async {
    for (final category in AppDataService.instance.missionCategories) {
      for (final mission in category.missions) {
        if (mission.id == missionId && mission.isCompleted) return true;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final local = prefs.getBool('$_keyPrefix$missionId') ?? false;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(UserIdProvider.currentUserId)
          .collection('mission_progress')
          .doc(missionId)
          .get();
      final remote = snapshot.data()?['isCompleted'] == true;
      if (remote && !local) {
        await prefs.setBool('$_keyPrefix$missionId', true);
      }
      return remote;
    } catch (error) {
      AppLogger.warning('PROGRESS: using offline mirror: $error');
      return local;
    }
  }

  /// Solo refleja localmente una finalizacion ya reclamada por
  /// GamificationService.
  Future<void> completeMission(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_keyPrefix$missionId', true);
    AppDataService.instance.markMissionCompleted(missionId);
  }

  Future<Map<String, bool>> getCategoryProgress(List<String> missionIds) async {
    final result = <String, bool>{};
    await Future.wait(
      missionIds.map((id) async => result[id] = await isMissionCompleted(id)),
    );
    return result;
  }

  Future<void> resetMission(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$missionId');
  }

  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
