import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/core/services/user_id_provider.dart';
import 'package:piensa_play/core/services/gamification_service.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import 'package:piensa_play/features/achievements/domain/entities/achievement.dart';
import 'package:piensa_play/features/missions/domain/entities/unified_question.dart';

/// Servicio para gestionar la pregunta diaria
/// Usa pool de 30 preguntas, selección por día del mes
class DailyQuestionService {
  static final DailyQuestionService _instance =
      DailyQuestionService._internal();
  factory DailyQuestionService() => _instance;
  DailyQuestionService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GamificationService _gamificationService = GamificationService();

  // Cache local
  UnifiedQuestion? _todaysQuestion;
  DateTime? _lastFetchDate;

  /// Obtiene la fecha de hoy como string (YYYY-MM-DD)
  String get _todayString {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Genera un índice pseudoaleatorio basado en la fecha
  /// Todos los usuarios obtienen el mismo índice el mismo día
  int _getDailyIndex(int poolSize) {
    final now = DateTime.now();
    // Hash simple: año * 10000 + mes * 100 + día
    final dateHash = now.year * 10000 + now.month * 100 + now.day;
    return dateHash % poolSize;
  }

  /// Referencia a daily_progress del usuario
  DocumentReference _dailyProgressRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_progress')
        .doc('current');
  }

  /// Verifica si ya respondió hoy
  Future<bool> hasAnsweredToday() async {
    try {
      final userId = UserIdProvider.currentUserId;
      final doc = await _dailyProgressRef(userId).get();

      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return false;

      final lastAnswered = data['lastAnsweredDate'] as String?;
      return lastAnswered == _todayString;
    } catch (e) {
      AppLogger.error('DAILY: Error checking if answered today: $e');
      return false;
    }
  }

  /// Obtiene la pregunta del día desde pool de daily_questions
  /// Selección consistente: día 1 → daily_01, día 15 → daily_15, etc.
  Future<UnifiedQuestion?> getTodaysQuestion() async {
    try {
      // Si ya tenemos la pregunta de hoy en cache, retornarla
      final now = DateTime.now();
      if (_todaysQuestion != null &&
          _lastFetchDate != null &&
          _lastFetchDate!.year == now.year &&
          _lastFetchDate!.month == now.month &&
          _lastFetchDate!.day == now.day) {
        return _todaysQuestion;
      }

      // Cargar todas las preguntas del pool y seleccionar una basada en la fecha
      final snapshot = await _firestore.collection('daily_questions').get();

      if (snapshot.docs.isEmpty) {
        AppLogger.error('DAILY: No questions in daily_questions pool');
        return null;
      }

      // Selección pseudoaleatoria pero consistente para todos
      final index = _getDailyIndex(snapshot.docs.length);
      final selectedDoc = snapshot.docs[index];

      AppLogger.log(
        'DAILY: Selected question index $index of ${snapshot.docs.length}',
      );

      _todaysQuestion = UnifiedQuestion.fromJson(selectedDoc.data());

      _lastFetchDate = now;

      AppLogger.log('DAILY: Today\'s question: ${_todaysQuestion?.title}');
      return _todaysQuestion;
    } catch (e) {
      AppLogger.error('DAILY: Error getting today\'s question: $e');
      return null;
    }
  }

  /// Registra la respuesta y otorga recompensas usando GamificationService
  Future<Map<String, int>> submitAnswer(bool isCorrect) async {
    try {
      final userId = UserIdProvider.currentUserId;

      // Calcular recompensas
      final xp = isCorrect
          ? GamificationConfig.xpPerDailyCorrect
          : GamificationConfig.xpPerDailyIncorrect;
      final coins = isCorrect
          ? GamificationConfig.coinsPerDailyCorrect
          : GamificationConfig.coinsPerDailyIncorrect;

      // Obtener progreso actual del usuario
      final progressDoc = await _dailyProgressRef(userId).get();

      int currentStreak = 0;
      int bestStreak = 0;
      int totalAnswered = 0;
      int totalCorrect = 0;
      String? lastAnsweredDate;

      if (progressDoc.exists) {
        final data = progressDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          currentStreak = data['streak'] ?? 0;
          bestStreak = data['bestStreak'] ?? 0;
          totalAnswered = data['totalAnswered'] ?? 0;
          totalCorrect = data['totalCorrect'] ?? 0;
          lastAnsweredDate = data['lastAnsweredDate'] as String?;
        }
      }

      // Calcular nuevo streak
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayString =
          '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

      int newStreak;
      if (lastAnsweredDate == yesterdayString) {
        newStreak = currentStreak + 1;
      } else if (lastAnsweredDate == _todayString) {
        newStreak = currentStreak;
      } else {
        newStreak = 1;
      }

      final newBestStreak = newStreak > bestStreak ? newStreak : bestStreak;

      // Guardar progreso diario en subcolección del usuario
      await _dailyProgressRef(userId).set({
        'lastAnsweredDate': _todayString,
        'streak': newStreak,
        'bestStreak': newBestStreak,
        'totalAnswered': totalAnswered + 1,
        'totalCorrect': totalCorrect + (isCorrect ? 1 : 0),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Usar GamificationService para actualizar XP y monedas
      final achievement = await _gamificationService.getAchievement();
      final newTotalXP = achievement.totalXP + xp;
      final newCoins = achievement.coins + coins;

      // Guardar en la misma estructura que usa GamificationService
      final newLevel = Achievement.calculateLevel(newTotalXP);
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .set({
            'totalXP': newTotalXP,
            'coins': newCoins,
            'currentLevel': newLevel,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      // IMPORTANTE: Actualizar caché de AppDataService para sincronizar UI
      final updatedAchievement = achievement.copyWith(
        totalXP: newTotalXP,
        coins: newCoins,
        currentLevel: newLevel,
      );
      AppDataService.instance.updateAchievement(updatedAchievement);

      // Actualizar caché de daily progress
      AppDataService.instance.updateDailyProgress(
        streak: newStreak,
        bestStreak: newBestStreak,
        totalAnswered: totalAnswered + 1,
      );

      AppLogger.success(
        'DAILY: Rewards granted - XP: +$xp, Coins: +$coins, Streak: $newStreak',
      );

      return {
        'xp': xp,
        'coins': coins,
        'streak': newStreak,
        'totalXP': newTotalXP,
        'totalCoins': newCoins,
      };
    } catch (e) {
      AppLogger.error('DAILY: Error submitting answer: $e');
      return {'xp': 0, 'coins': 0, 'streak': 0};
    }
  }

  /// Obtiene el tiempo restante hasta la próxima pregunta
  Duration getTimeUntilNextQuestion() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  /// Obtiene el streak actual
  Future<int> getStreak() async {
    try {
      final userId = UserIdProvider.currentUserId;
      final doc = await _dailyProgressRef(userId).get();

      if (!doc.exists) return 0;
      final data = doc.data() as Map<String, dynamic>?;
      return data?['streak'] ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
