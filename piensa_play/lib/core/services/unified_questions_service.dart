import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/firestore_provider.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import '../../features/missions/domain/entities/unified_question.dart';

/// Service to load UnifiedQuestions from Firebase with offline support
class UnifiedQuestionsService {
  final FirebaseFirestore _firestore = FirestoreProvider.instance;

  /// Load all questions for a specific mission
  /// SINGLETON-FIRST: Las preguntas ya están en memoria desde el splash
  Future<List<UnifiedQuestion>> getQuestionsForMission(String missionId) async {
    // 1. PRIMERO: Revisar el singleton (instantáneo, 0ms)
    final cachedQuestions = AppDataService.instance.getQuestionsForMission(
      missionId,
    );
    if (cachedQuestions.isNotEmpty) {
      print(
        '⚡ Questions loaded from memory (instant): ${cachedQuestions.length}',
      );
      return cachedQuestions;
    }

    // 2. FALLBACK: Si no está en memoria, usar Firestore cache
    print('🔵 Questions not in memory, loading from Firestore cache...');
    try {
      final snapshot = await _firestore
          .collection('unified_questions')
          .where('missionId', isEqualTo: missionId)
          .orderBy('order')
          .get(const GetOptions(source: Source.cache));

      final questions = snapshot.docs.map((doc) {
        return UnifiedQuestion.fromJson(doc.data());
      }).toList();

      print('📦 Loaded ${questions.length} questions from Firestore cache');
      return questions;
    } catch (e) {
      print('❌ Error loading questions: $e');
      return [];
    }
  }

  /// Load all unified questions (for pre-caching during splash)
  Future<Map<String, List<UnifiedQuestion>>> getAllQuestions() async {
    try {
      print('🔵 Loading all unified questions for caching');

      QuerySnapshot<Map<String, dynamic>> snapshot;

      try {
        snapshot = await _firestore
            .collection('unified_questions')
            .orderBy('order')
            .get(const GetOptions(source: Source.serverAndCache));

        print('🟢 Loaded ${snapshot.docs.length} total questions from server');
      } catch (e) {
        print('⚠️ Server unavailable, trying cache...');

        snapshot = await _firestore
            .collection('unified_questions')
            .orderBy('order')
            .get(const GetOptions(source: Source.cache));

        print('📦 Loaded ${snapshot.docs.length} total questions from cache');
      }

      final Map<String, List<UnifiedQuestion>> questionsByMission = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final question = UnifiedQuestion.fromJson(data);
        final missionId = data['missionId'] as String;

        questionsByMission.putIfAbsent(missionId, () => []);
        questionsByMission[missionId]!.add(question);
      }

      print('🟢 Cached ${snapshot.docs.length} total questions');
      return questionsByMission;
    } catch (e) {
      print('❌ Error loading all questions: $e');
      return {};
    }
  }

  /// Pre-cache all questions (call during splash)
  /// This ensures questions are available offline
  Future<void> preCacheAllQuestions() async {
    try {
      print('🔵 Pre-caching all unified questions...');

      // Cargar desde servidor para poblar el caché
      final snapshot = await _firestore
          .collection('unified_questions')
          .get(const GetOptions(source: Source.server));

      print('✅ Pre-cached ${snapshot.docs.length} questions for offline use');
    } catch (e) {
      print('⚠️ Could not pre-cache questions (offline?): $e');
      // No es error crítico, el caché ya existente seguirá funcionando
    }
  }
}
