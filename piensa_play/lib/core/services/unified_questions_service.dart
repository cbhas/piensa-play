import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/missions/domain/entities/unified_question.dart';
import 'app_data_service.dart';
import 'logger_service.dart';

/// Carga preguntas unificadas desde memoria, cache local y servidor.
class UnifiedQuestionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UnifiedQuestion>> getQuestionsForMission(String missionId) async {
    final cached = AppDataService.instance.getQuestionsForMission(missionId);
    if (cached.isNotEmpty) {
      AppLogger.log('Questions loaded from memory: ${cached.length}');
      return cached;
    }

    try {
      final snapshot = await _firestore
          .collection('unified_questions')
          .where('missionId', isEqualTo: missionId)
          .orderBy('order')
          .get(const GetOptions(source: Source.cache));
      return snapshot.docs
          .map((doc) => UnifiedQuestion.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (error) {
      AppLogger.warning('Questions unavailable for $missionId: $error');
      return [];
    }
  }

  Future<Map<String, List<UnifiedQuestion>>> getAllQuestions() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;
      try {
        snapshot = await _firestore
            .collection('unified_questions')
            .orderBy('order')
            .get(const GetOptions(source: Source.serverAndCache));
      } catch (error) {
        AppLogger.warning('Question server unavailable: $error');
        snapshot = await _firestore
            .collection('unified_questions')
            .orderBy('order')
            .get(const GetOptions(source: Source.cache));
      }

      final byMission = <String, List<UnifiedQuestion>>{};
      for (final document in snapshot.docs) {
        final data = document.data();
        final missionId = data['missionId'] as String?;
        if (missionId == null || missionId.isEmpty) continue;
        byMission
            .putIfAbsent(missionId, () => [])
            .add(UnifiedQuestion.fromJson({'id': document.id, ...data}));
      }
      AppLogger.success('Cached ${snapshot.docs.length} unified questions');
      return byMission;
    } catch (error) {
      AppLogger.error('Could not load unified questions: $error');
      return {};
    }
  }

  Future<void> preCacheAllQuestions() async {
    try {
      final snapshot = await _firestore
          .collection('unified_questions')
          .get(const GetOptions(source: Source.server));
      AppLogger.success('Pre-cached ${snapshot.docs.length} questions');
    } catch (error) {
      AppLogger.warning('Question pre-cache skipped: $error');
    }
  }
}
