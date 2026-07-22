import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';
import '../../domain/entities/veracidadville/quiz_question.dart';
import '../../domain/entities/veracidadville/quiz_element.dart';
import '../../domain/entities/veracidadville/question_type.dart';
import '../../../../core/localization/localized_text.dart';

class MissionsRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================================================================
  // READ METHODS (from global collections)
  // =========================================================================

  /// Fetch all mission categories from Firestore
  Future<List<MissionCategory>> getMissionCategories() async {
    AppLogger.log('MISSIONS REMOTE: Fetching categories from Firestore...');

    try {
      // 1. Get all categories
      final categoriesSnapshot = await _firestore
          .collection('mission_categories')
          .orderBy('order')
          .get();

      if (categoriesSnapshot.docs.isEmpty) {
        AppLogger.warning('MISSIONS REMOTE: No categories found');
        return [];
      }

      // 2. Get all missions
      final missionsSnapshot = await _firestore
          .collection('missions')
          .orderBy('order')
          .get();

      // 3. Group missions by categoryId
      final missionsByCategory = <String, List<Mission>>{};
      for (final doc in missionsSnapshot.docs) {
        final data = doc.data();
        final categoryId = data['categoryId'] as String? ?? '';

        // DEBUG: Ver qué type viene de Firebase
        AppLogger.debug(
          'FIREBASE: Mission ${doc.id}, type field: "${data['type']}"',
        );

        final mission = Mission(
          id: doc.id,
          title: data['title'] ?? '',
          subtitle: data['subtitle'] ?? '',
          description: data['description'] ?? '',
          isCompleted: false, // Will be updated from user data
          iconName: data['iconName'] ?? '',
          type: MissionTypeExtension.fromJson(data['type'] as String?),
          questions: [], // Will be loaded separately when needed
        );

        missionsByCategory.putIfAbsent(categoryId, () => []);
        missionsByCategory[categoryId]!.add(mission);
      }

      // 4. Build categories with their missions
      final categories = categoriesSnapshot.docs.map((doc) {
        final data = doc.data();
        return MissionCategory(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          iconName: data['iconName'] ?? '',
          colorHex: data['colorHex'] ?? '0xFF6EC6FF',
          missions: missionsByCategory[doc.id] ?? [],
        );
      }).toList();

      AppLogger.success(
        'MISSIONS REMOTE: Loaded ${categories.length} categories',
      );
      return categories;
    } catch (e) {
      AppLogger.error('MISSIONS REMOTE: Error fetching categories: $e');
      rethrow;
    }
  }

  /// Fetch questions for a specific mission
  Future<List<QuizQuestion>> getQuestionsByMission(String missionId) async {
    AppLogger.log(
      'MISSIONS REMOTE: Fetching questions for mission $missionId...',
    );

    try {
      final snapshot = await _firestore
          .collection('questions')
          .where('missionId', isEqualTo: missionId)
          .orderBy('order')
          .get();

      if (snapshot.docs.isEmpty) {
        AppLogger.warning(
          'MISSIONS REMOTE: No questions found for mission $missionId',
        );
        return [];
      }

      final questions = snapshot.docs.map((doc) {
        final data = doc.data();
        return QuizQuestion(
          id: doc.id,
          newsTitle: LocalizedText.fromJson(data['newsTitle']),
          newsContent: LocalizedText.fromJson(data['newsContent']),
          newsSource: LocalizedText.fromJson(data['newsSource']),
          newsDate: LocalizedText.fromJson(data['newsDate']),
          newsAuthor: LocalizedText.fromJson(data['newsAuthor']),
          newsShares: LocalizedText.fromJson(data['newsShares']),
          newsImage: data['newsImage'],
          elements: _parseElements(data['elements']),
          explanation: LocalizedText.fromJson(data['explanation']),
          type: _parseQuestionType(data['type']),
          correctAnswer: data['correctAnswer'] as bool?,
          clues: (data['clues'] as List<dynamic>?)
              ?.map((c) => LocalizedText.fromJson(c))
              .toList(),
        );
      }).toList();

      AppLogger.success(
        'MISSIONS REMOTE: Loaded ${questions.length} questions',
      );
      return questions;
    } catch (e) {
      AppLogger.error('MISSIONS REMOTE: Error fetching questions: $e');
      rethrow;
    }
  }

  /// Fetch all questions (for preloading)
  Future<Map<String, List<QuizQuestion>>> getAllQuestions() async {
    AppLogger.log('MISSIONS REMOTE: Fetching all questions...');

    try {
      final snapshot = await _firestore
          .collection('questions')
          .orderBy('order')
          .get();

      final questionsByMission = <String, List<QuizQuestion>>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final missionId = data['missionId'] as String? ?? '';

        final question = QuizQuestion(
          id: doc.id,
          newsTitle: LocalizedText.fromJson(data['newsTitle']),
          newsContent: LocalizedText.fromJson(data['newsContent']),
          newsSource: LocalizedText.fromJson(data['newsSource']),
          newsDate: LocalizedText.fromJson(data['newsDate']),
          newsAuthor: LocalizedText.fromJson(data['newsAuthor']),
          newsShares: LocalizedText.fromJson(data['newsShares']),
          newsImage: data['newsImage'],
          elements: _parseElements(data['elements']),
          explanation: LocalizedText.fromJson(data['explanation']),
          type: _parseQuestionType(data['type']),
          correctAnswer: data['correctAnswer'] as bool?,
          clues: (data['clues'] as List<dynamic>?)
              ?.map((c) => LocalizedText.fromJson(c))
              .toList(),
        );

        questionsByMission.putIfAbsent(missionId, () => []);
        questionsByMission[missionId]!.add(question);
      }

      AppLogger.success(
        'MISSIONS REMOTE: Loaded questions for ${questionsByMission.keys.length} missions',
      );
      return questionsByMission;
    } catch (e) {
      AppLogger.error('MISSIONS REMOTE: Error fetching all questions: $e');
      rethrow;
    }
  }

  // =========================================================================
  // HELPER METHODS
  // =========================================================================

  List<QuizElement> _parseElements(dynamic elementsData) {
    if (elementsData == null) return [];

    final elements = elementsData as List<dynamic>;
    return elements.map((e) {
      final map = e as Map<String, dynamic>;
      return QuizElement(
        id: map['id'] ?? '',
        text: LocalizedText.fromJson(map['text']),
        icon: map['icon'] ?? '',
        isCorrect: map['isCorrect'] ?? false,
      );
    }).toList();
  }

  QuestionType _parseQuestionType(dynamic typeData) {
    if (typeData == null) return QuestionType.quiz;
    return QuestionTypeExtension.fromJson(typeData as String);
  }

  // =========================================================================
  // WRITE METHODS (for user progress - existing functionality)
  // =========================================================================

  /// Save user's mission progress
  Future<void> saveUserMissionProgress(
    String userId,
    String missionId,
    bool isCompleted,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('mission_progress')
          .doc(missionId)
          .set({
            'isCompleted': isCompleted,
            'completedAt': isCompleted ? FieldValue.serverTimestamp() : null,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      AppLogger.success('Mission progress saved for $missionId');
    } catch (e) {
      AppLogger.error('Error saving mission progress: $e');
      rethrow;
    }
  }

  /// Get user's mission progress (which missions are completed)
  Future<Map<String, bool>> getUserMissionProgress(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mission_progress')
          .get();

      final progress = <String, bool>{};
      for (final doc in snapshot.docs) {
        progress[doc.id] = doc.data()['isCompleted'] ?? false;
      }

      return progress;
    } catch (e) {
      AppLogger.error('Error getting mission progress: $e');
      return {};
    }
  }

  // Legacy method - kept for backwards compatibility
  Future<void> saveMissionCategories(
    String userId,
    List<MissionCategory> categories,
  ) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('missions')
          .doc('categories');

      await docRef.set({
        'categories': categories
            .map(
              (cat) => {
                'id': cat.id,
                'title': cat.title,
                'description': cat.description,
                'iconName': cat.iconName,
                'colorHex': cat.colorHex,
                'missions': cat.missions
                    .map(
                      (m) => {
                        'id': m.id,
                        'title': m.title,
                        'description': m.description,
                        'isCompleted': m.isCompleted,
                        'iconName': m.iconName,
                      },
                    )
                    .toList(),
              },
            )
            .toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppLogger.error('Error guardando misiones en Firestore: $e');
      rethrow;
    }
  }
}
