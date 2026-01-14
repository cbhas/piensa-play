import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:piensa_play/core/services/logger_service.dart';
import '../datasources/missions_local_datasource.dart';
import '../datasources/missions_remote_datasource.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';
import '../../domain/entities/veracidadville/quiz_question.dart';

/// Repository that handles mission data with remote-first strategy
/// and fallback to local hardcoded data.
///
/// Data Flow:
/// 1. Try to fetch from Firebase (remote)
/// 2. If successful, cache locally
/// 3. If failed, try to load from cache
/// 4. If no cache, use hardcoded fallback
class MissionsRepository {
  final MissionsRemoteDatasource _remoteDatasource;
  final MissionsLocalDatasource _localDatasource;

  static const String _categoriesCacheKey = 'missions_categories_cache';
  static const String _questionsCacheKey = 'missions_questions_cache';

  MissionsRepository({
    MissionsRemoteDatasource? remoteDatasource,
    MissionsLocalDatasource? localDatasource,
  }) : _remoteDatasource = remoteDatasource ?? MissionsRemoteDatasource(),
       _localDatasource = localDatasource ?? MissionsLocalDatasource();

  // =========================================================================
  // PUBLIC METHODS
  // =========================================================================

  /// Get mission categories with missions (remote-first with fallback)
  Future<List<MissionCategory>> getMissionCategories(String userId) async {
    AppLogger.log('MISSIONS REPO: Getting categories for user $userId');

    try {
      // 1. Try remote first
      final categories = await _remoteDatasource.getMissionCategories();

      if (categories.isNotEmpty) {
        // Get user progress to mark completed missions
        final progress = await _remoteDatasource.getUserMissionProgress(userId);
        final categoriesWithProgress = _applyProgress(categories, progress);

        // Cache the data
        await _cacheCategories(categoriesWithProgress);

        AppLogger.success(
          'MISSIONS REPO: Loaded ${categories.length} categories from Firebase',
        );
        return categoriesWithProgress;
      }
    } catch (e) {
      AppLogger.warning('MISSIONS REPO: Remote fetch failed: $e');
    }

    // 2. Try cache
    try {
      final cached = await _getCachedCategories();
      if (cached.isNotEmpty) {
        AppLogger.log(
          'MISSIONS REPO: Loaded ${cached.length} categories from cache',
        );
        return cached;
      }
    } catch (e) {
      AppLogger.warning('MISSIONS REPO: Cache load failed: $e');
    }

    // 3. Fallback to hardcoded
    AppLogger.warning('MISSIONS REPO: Using hardcoded fallback');
    return _localDatasource.getMissionCategories(userId);
  }

  /// Get questions for a specific mission
  Future<List<QuizQuestion>> getQuestionsForMission(String missionId) async {
    AppLogger.log('MISSIONS REPO: Getting questions for mission $missionId');

    try {
      // 1. Try remote first
      final questions = await _remoteDatasource.getQuestionsByMission(
        missionId,
      );

      if (questions.isNotEmpty) {
        // Cache the questions
        await _cacheQuestions(missionId, questions);

        AppLogger.success(
          'MISSIONS REPO: Loaded ${questions.length} questions from Firebase',
        );
        return questions;
      }
    } catch (e) {
      AppLogger.warning('MISSIONS REPO: Remote fetch failed: $e');
    }

    // 2. Try cache
    try {
      final cached = await _getCachedQuestions(missionId);
      if (cached.isNotEmpty) {
        AppLogger.log(
          'MISSIONS REPO: Loaded ${cached.length} questions from cache',
        );
        return cached;
      }
    } catch (e) {
      AppLogger.warning('MISSIONS REPO: Cache load failed: $e');
    }

    // 3. Fallback to hardcoded - find in local datasource
    AppLogger.warning('MISSIONS REPO: Using hardcoded fallback for questions');
    return _getHardcodedQuestions(missionId);
  }

  /// Mark a mission as completed
  Future<void> completeMission(String userId, String missionId) async {
    try {
      await _remoteDatasource.saveUserMissionProgress(userId, missionId, true);
      AppLogger.success(
        'MISSIONS REPO: Mission $missionId marked as completed',
      );
    } catch (e) {
      AppLogger.error('MISSIONS REPO: Failed to save mission progress: $e');
      rethrow;
    }
  }

  // =========================================================================
  // PRIVATE HELPER METHODS
  // =========================================================================

  List<MissionCategory> _applyProgress(
    List<MissionCategory> categories,
    Map<String, bool> progress,
  ) {
    return categories.map((category) {
      final updatedMissions = category.missions.map((mission) {
        return Mission(
          id: mission.id,
          title: mission.title,
          subtitle: mission.subtitle,
          description: mission.description,
          isCompleted: progress[mission.id] ?? false,
          iconName: mission.iconName,
          type: mission.type,
          questions: mission.questions,
        );
      }).toList();

      return MissionCategory(
        id: category.id,
        title: category.title,
        description: category.description,
        iconName: category.iconName,
        colorHex: category.colorHex,
        missions: updatedMissions,
      );
    }).toList();
  }

  // =========================================================================
  // CACHING METHODS
  // =========================================================================

  Future<void> _cacheCategories(List<MissionCategory> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = categories
          .map(
            (c) => {
              'id': c.id,
              'title': c.title,
              'description': c.description,
              'iconName': c.iconName,
              'colorHex': c.colorHex,
              'missions': c.missions
                  .map(
                    (m) => {
                      'id': m.id,
                      'title': m.title,
                      'subtitle': m.subtitle,
                      'description': m.description,
                      'isCompleted': m.isCompleted,
                      'iconName': m.iconName,
                      'type': m.type.toJson(),
                    },
                  )
                  .toList(),
            },
          )
          .toList();

      await prefs.setString(_categoriesCacheKey, jsonEncode(jsonData));
      AppLogger.success('MISSIONS REPO: Categories cached');
    } catch (e) {
      AppLogger.warning('MISSIONS REPO: Failed to cache categories: $e');
    }
  }

  Future<List<MissionCategory>> _getCachedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_categoriesCacheKey);

    if (jsonString == null) return [];

    final jsonData = jsonDecode(jsonString) as List<dynamic>;
    return jsonData.map((c) {
      final catMap = c as Map<String, dynamic>;
      final missions = (catMap['missions'] as List<dynamic>).map((m) {
        final missionMap = m as Map<String, dynamic>;
        return Mission(
          id: missionMap['id'] ?? '',
          title: missionMap['title'] ?? '',
          subtitle: missionMap['subtitle'] ?? '',
          description: missionMap['description'] ?? '',
          isCompleted: missionMap['isCompleted'] ?? false,
          iconName: missionMap['iconName'] ?? '',
          type: MissionTypeExtension.fromJson(missionMap['type'] as String?),
          questions: [],
        );
      }).toList();

      return MissionCategory(
        id: catMap['id'] ?? '',
        title: catMap['title'] ?? '',
        description: catMap['description'] ?? '',
        iconName: catMap['iconName'] ?? '',
        colorHex: catMap['colorHex'] ?? '0xFF6EC6FF',
        missions: missions,
      );
    }).toList();
  }

  Future<void> _cacheQuestions(
    String missionId,
    List<QuizQuestion> questions,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_questionsCacheKey}_$missionId';
      final jsonData = questions.map((q) => q.toJson()).toList();

      await prefs.setString(key, jsonEncode(jsonData));
      AppLogger.success('MISSIONS REPO: Questions for $missionId cached');
    } catch (e) {
      AppLogger.warning('MISSIONS REPO: Failed to cache questions: $e');
    }
  }

  Future<List<QuizQuestion>> _getCachedQuestions(String missionId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_questionsCacheKey}_$missionId';
    final jsonString = prefs.getString(key);

    if (jsonString == null) return [];

    final jsonData = jsonDecode(jsonString) as List<dynamic>;
    return jsonData.map((q) {
      return QuizQuestion.fromJson(q as Map<String, dynamic>);
    }).toList();
  }

  /// Get hardcoded questions as fallback
  List<QuizQuestion> _getHardcodedQuestions(String missionId) {
    // Import the hardcoded data classes and return appropriate questions
    // This maintains backwards compatibility
    switch (missionId) {
      case 'fake_news':
        return _getVeracidadvilleQuizQuestions();
      case 'titular':
        return _getTrueFalseQuestions();
      case 'mensaje_escondido':
        return _getZonaCeroWordQuestions();
      case 'q1_phishing':
      case 'q2_malware':
      case 'q3_passwords':
        return _getCiberseguridadQuestions();
      default:
        return [];
    }
  }

  // Hardcoded fallback methods - import from existing data files
  List<QuizQuestion> _getVeracidadvilleQuizQuestions() {
    // These would be imported from veracidadville_quiz_data.dart
    // For now, return empty and the local datasource handles it
    return [];
  }

  List<QuizQuestion> _getTrueFalseQuestions() {
    return [];
  }

  List<QuizQuestion> _getZonaCeroWordQuestions() {
    return [];
  }

  List<QuizQuestion> _getCiberseguridadQuestions() {
    return [];
  }
}
