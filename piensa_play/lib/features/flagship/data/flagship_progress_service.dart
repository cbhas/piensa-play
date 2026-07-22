import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LearningImpact {
  final int decisions;
  final int correctFirstTry;
  final int missionsCompleted;
  final int? baselineScore;
  final int? postScore;

  const LearningImpact({
    required this.decisions,
    required this.correctFirstTry,
    required this.missionsCompleted,
    this.baselineScore,
    this.postScore,
  });

  double get firstTryRate => decisions == 0 ? 0 : correctFirstTry / decisions;
}

/// Metricas agregadas y locales: no guarda nombre, edad ni contenido escrito.
class FlagshipProgressService {
  static const _completedKey = 'flagship_completed_missions';
  static const _metricsKey = 'flagship_learning_metrics';
  static const _baselineKey = 'flagship_baseline_score';
  static const _postKey = 'flagship_post_score';

  Future<Set<String>> completedMissions() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_completedKey) ?? const []).toSet();
  }

  Future<void> completeMission(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = (prefs.getStringList(_completedKey) ?? const []).toSet();
    completed.add(missionId);
    await prefs.setStringList(_completedKey, completed.toList()..sort());
  }

  Future<void> recordDecision({
    required String missionId,
    required String challengeId,
    required bool correctFirstTry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metricsKey);
    final metrics = raw == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw));
    final decisionKey = '$missionId:$challengeId';
    if (metrics.containsKey(decisionKey)) return;
    metrics[decisionKey] = {'correctFirstTry': correctFirstTry};
    await prefs.setString(_metricsKey, jsonEncode(metrics));
  }

  Future<LearningImpact> impact() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metricsKey);
    final metrics = raw == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw));
    final correct = metrics.values.where((value) {
      return value is Map && value['correctFirstTry'] == true;
    }).length;
    final completed = await completedMissions();
    return LearningImpact(
      decisions: metrics.length,
      correctFirstTry: correct,
      missionsCompleted: completed.length,
      baselineScore: prefs.getInt(_baselineKey),
      postScore: prefs.getInt(_postKey),
    );
  }

  Future<void> saveAssessment({
    required bool isPost,
    required int score,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(isPost ? _postKey : _baselineKey, score);
  }
}
