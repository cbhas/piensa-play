import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/missions/domain/entities/unified_question.dart';

/// Service to load UnifiedQuestions from Firebase
class UnifiedQuestionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Load all questions for a specific mission
  Future<List<UnifiedQuestion>> getQuestionsForMission(String missionId) async {
    try {
      print('🔵 Loading unified questions for mission: $missionId');

      final snapshot = await _firestore
          .collection('unified_questions')
          .where('missionId', isEqualTo: missionId)
          .orderBy('order')
          .get();

      final questions = snapshot.docs.map((doc) {
        final data = doc.data();
        return UnifiedQuestion.fromJson(data);
      }).toList();

      print('🟢 Loaded ${questions.length} questions for mission: $missionId');
      return questions;
    } catch (e) {
      print('❌ Error loading questions: $e');
      return [];
    }
  }

  /// Load all unified questions (for caching)
  Future<Map<String, List<UnifiedQuestion>>> getAllQuestions() async {
    try {
      print('🔵 Loading all unified questions');

      final snapshot = await _firestore
          .collection('unified_questions')
          .orderBy('order')
          .get();

      final Map<String, List<UnifiedQuestion>> questionsByMission = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final question = UnifiedQuestion.fromJson(data);
        final missionId = data['missionId'] as String;

        questionsByMission.putIfAbsent(missionId, () => []);
        questionsByMission[missionId]!.add(question);
      }

      print('🟢 Loaded ${snapshot.docs.length} total questions');
      return questionsByMission;
    } catch (e) {
      print('❌ Error loading all questions: $e');
      return {};
    }
  }
}
