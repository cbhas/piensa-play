import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/reward_policy.dart';
import '../../features/achievements/domain/entities/achievement.dart';
import '../../features/missions/domain/entities/unified_question.dart';
import 'app_data_service.dart';
import 'connectivity_service.dart';
import 'firestore_provider.dart';
import 'logger_service.dart';
import 'user_id_provider.dart';
import 'widget_service.dart';

/// Pregunta diaria estable e idempotente.
///
/// Igual que [GamificationService], tiene dos caminos de escritura: una
/// transaccion cuando hay red y un camino optimista cuando no la hay
/// (`runTransaction` no funciona offline). Ambos usan [DailyRewardPolicy], de
/// modo que el calculo de racha y la guarda de "ya respondio hoy" son
/// identicos en los dos.
class DailyQuestionService {
  static final DailyQuestionService _instance =
      DailyQuestionService._internal();
  factory DailyQuestionService() => _instance;
  DailyQuestionService._internal();

  final FirebaseFirestore _firestore = FirestoreProvider.instance;
  UnifiedQuestion? _todaysQuestion;
  DateTime? _lastFetchDate;

  String get _todayString => _dateString(DateTime.now());

  String _dateString(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String get _yesterdayString =>
      _dateString(DateTime.now().subtract(const Duration(days: 1)));

  int _getDailyIndex(int poolSize) {
    final now = DateTime.now();
    return (now.year * 10000 + now.month * 100 + now.day) % poolSize;
  }

  DocumentReference<Map<String, dynamic>> _dailyProgressRef(String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_progress')
          .doc('current');

  DocumentReference<Map<String, dynamic>> _achievementRef(String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current');

  Future<bool> hasAnsweredToday() async {
    try {
      final snapshot = await _dailyProgressRef(
        UserIdProvider.currentUserId,
      ).get();
      return snapshot.data()?['lastAnsweredDate'] == _todayString;
    } catch (error) {
      AppLogger.warning('DAILY: answer state unavailable: $error');
      return false;
    }
  }

  Future<UnifiedQuestion?> getTodaysQuestion({bool english = false}) async {
    final now = DateTime.now();
    if (_todaysQuestion != null &&
        _lastFetchDate != null &&
        _dateString(_lastFetchDate!) == _dateString(now)) {
      return _todaysQuestion;
    }

    try {
      // El orden por ID hace que el indice diario sea igual en cada dispositivo.
      final snapshot = await _firestore
          .collection('daily_questions')
          .orderBy(FieldPath.documentId)
          .get();
      if (snapshot.docs.isEmpty) return _offlineQuestion(english);

      final selected = snapshot.docs[_getDailyIndex(snapshot.docs.length)];
      _todaysQuestion = UnifiedQuestion.fromJson({
        'id': selected.id,
        ...selected.data(),
      });
      _lastFetchDate = now;
      return _todaysQuestion;
    } catch (error) {
      AppLogger.warning('DAILY: using offline question: $error');
      _todaysQuestion = _offlineQuestion(english);
      _lastFetchDate = now;
      return _todaysQuestion;
    }
  }

  /// Registra la respuesta del dia y otorga recompensas una sola vez.
  ///
  /// Una segunda llamada el mismo dia devuelve cero y no altera contadores,
  /// tanto online como offline.
  Future<Map<String, int>> submitAnswer(bool isCorrect) async {
    if (ConnectivityService.instance.isOnline) {
      try {
        return await _submitAtomically(isCorrect);
      } catch (error) {
        AppLogger.warning(
          'DAILY: transaccion no disponible, usando camino offline: $error',
        );
      }
    }
    return _submitOptimistically(isCorrect);
  }

  // ---------------------------------------------------------------------------
  // Camino atomico (requiere conexion)
  // ---------------------------------------------------------------------------

  Future<Map<String, int>> _submitAtomically(bool isCorrect) async {
    final userId = UserIdProvider.currentUserId;
    final progressRef = _dailyProgressRef(userId);
    final achievementRef = _achievementRef(userId);

    var xpAwarded = 0;
    var coinsAwarded = 0;
    var streak = 0;
    var bestStreak = 0;
    var totalAnswered = 0;
    var updatedAchievement = Achievement.initial();

    await _firestore.runTransaction((transaction) async {
      final progressSnapshot = await transaction.get(progressRef);
      final achievementSnapshot = await transaction.get(achievementRef);
      final progress = progressSnapshot.data() ?? const <String, dynamic>{};

      updatedAchievement = achievementSnapshot.exists
          ? Achievement.fromJson(achievementSnapshot.data()!)
          : Achievement.initial();

      final decision = DailyRewardPolicy.decide(
        isCorrect: isCorrect,
        today: _todayString,
        yesterday: _yesterdayString,
        lastAnsweredDate: progress['lastAnsweredDate'] as String?,
        currentStreak: progress['streak'] as int? ?? 0,
        currentBestStreak: progress['bestStreak'] as int? ?? 0,
        currentTotalAnswered: progress['totalAnswered'] as int? ?? 0,
        currentTotalCorrect: progress['totalCorrect'] as int? ?? 0,
      );
      streak = decision.streak;
      bestStreak = decision.bestStreak;
      totalAnswered = decision.totalAnswered;
      if (!decision.grantReward) return;
      xpAwarded = decision.xp;
      coinsAwarded = decision.coins;

      final totalXP = updatedAchievement.totalXP + xpAwarded;
      updatedAchievement = updatedAchievement.copyWith(
        totalXP: totalXP,
        coins: updatedAchievement.coins + coinsAwarded,
        currentLevel: Achievement.calculateLevel(totalXP),
      );

      transaction.set(progressRef, {
        'lastAnsweredDate': _todayString,
        'streak': streak,
        'bestStreak': bestStreak,
        'totalAnswered': totalAnswered,
        'totalCorrect': decision.totalCorrect,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      transaction.set(achievementRef, {
        ...updatedAchievement.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

    if (xpAwarded > 0 || coinsAwarded > 0) {
      AppDataService.instance.updateAchievement(updatedAchievement);
      AppDataService.instance.updateDailyProgress(
        streak: streak,
        bestStreak: bestStreak,
        totalAnswered: totalAnswered,
      );
      await _updateWidget(streak);
    }

    return {
      'xp': xpAwarded,
      'coins': coinsAwarded,
      'streak': streak,
      'totalXP': updatedAchievement.totalXP,
      'totalCoins': updatedAchievement.coins,
    };
  }

  // ---------------------------------------------------------------------------
  // Camino optimista (funciona sin conexion)
  //
  // La racha es el gancho diario de la app: perderla por estar sin red seria
  // peor que arriesgar una carrera entre dispositivos, que aqui es improbable
  // (una respuesta al dia, por usuario).
  // ---------------------------------------------------------------------------

  Future<Map<String, int>> _submitOptimistically(bool isCorrect) async {
    try {
      final userId = UserIdProvider.currentUserId;

      // Lectura offline-ok: sale de la persistencia local de Firestore.
      final progressSnapshot = await _dailyProgressRef(userId).get();
      final progress = progressSnapshot.data() ?? const <String, dynamic>{};

      final decision = DailyRewardPolicy.decide(
        isCorrect: isCorrect,
        today: _todayString,
        yesterday: _yesterdayString,
        lastAnsweredDate: progress['lastAnsweredDate'] as String?,
        currentStreak: progress['streak'] as int? ?? 0,
        currentBestStreak: progress['bestStreak'] as int? ?? 0,
        currentTotalAnswered: progress['totalAnswered'] as int? ?? 0,
        currentTotalCorrect: progress['totalCorrect'] as int? ?? 0,
      );

      // Se lee de Firestore (offline sale de la persistencia local) en vez de
      // la cache en memoria: si la cache viniera fria devolveria
      // Achievement.initial() y la escritura reiniciaria el XP real a 0.
      final current = await _loadAchievement(userId);

      // Ya respondio hoy: no se altera nada.
      if (!decision.grantReward) {
        return {
          'xp': 0,
          'coins': 0,
          'streak': decision.streak,
          'totalXP': current.totalXP,
          'totalCoins': current.coins,
        };
      }

      final totalXP = current.totalXP + decision.xp;
      final updated = current.copyWith(
        totalXP: totalXP,
        coins: current.coins + decision.coins,
        currentLevel: Achievement.calculateLevel(totalXP),
      );

      // 1. Cache primero -> UI inmediata, online u offline.
      AppDataService.instance.updateAchievement(updated);
      AppDataService.instance.updateDailyProgress(
        streak: decision.streak,
        bestStreak: decision.bestStreak,
        totalAnswered: decision.totalAnswered,
      );

      // 2. Persistencia en segundo plano: se encola y sincroniza al reconectar.
      //    No se hace `await`: con persistencia activada el Future no resuelve
      //    mientras se esta offline.
      _dailyProgressRef(userId)
          .set({
            'lastAnsweredDate': _todayString,
            'streak': decision.streak,
            'bestStreak': decision.bestStreak,
            'totalAnswered': decision.totalAnswered,
            'totalCorrect': decision.totalCorrect,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .catchError((e) {
            AppLogger.error('DAILY: Error persisting daily progress: $e');
          });

      _achievementRef(userId)
          .set({
            ...updated.toJson(),
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .catchError((e) {
            AppLogger.error('DAILY: Error persisting achievement: $e');
          });

      await _updateWidget(decision.streak);

      AppLogger.success(
        'DAILY: Rewards granted (offline) - XP: +${decision.xp}, '
        'Coins: +${decision.coins}, Streak: ${decision.streak}',
      );

      return {
        'xp': decision.xp,
        'coins': decision.coins,
        'streak': decision.streak,
        'totalXP': updated.totalXP,
        'totalCoins': updated.coins,
      };
    } catch (error) {
      AppLogger.error('DAILY: Error submitting answer: $error');
      return {'xp': 0, 'coins': 0, 'streak': 0};
    }
  }

  Future<Achievement> _loadAchievement(String userId) async {
    try {
      final snapshot = await _achievementRef(userId).get();
      if (snapshot.exists) return Achievement.fromJson(snapshot.data()!);
    } catch (error) {
      AppLogger.warning('DAILY: achievement unavailable: $error');
    }
    return Achievement.initial();
  }

  Future<void> _updateWidget(int streak) async {
    try {
      await WidgetService().markAsCompleted(streak);
    } catch (error) {
      AppLogger.warning('DAILY: widget update skipped: $error');
    }
  }

  Duration getTimeUntilNextQuestion() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1).difference(now);
  }

  Future<int> getStreak() async {
    try {
      final snapshot = await _dailyProgressRef(
        UserIdProvider.currentUserId,
      ).get();
      return snapshot.data()?['streak'] as int? ?? 0;
    } catch (_) {
      return AppDataService.instance.dailyStreak;
    }
  }

  UnifiedQuestion _offlineQuestion(bool english) => english
      ? const UnifiedQuestion(
          id: 'offline_daily_source',
          type: QuestionType.quiz,
          title:
              'A surprising post has no author or source. What do you do first?',
          subtitle: 'Apply PIENSA before sharing.',
          options: [
            AnswerOption(
              id: 'share',
              text: 'Share it because it seems urgent',
              isCorrect: false,
            ),
            AnswerOption(
              id: 'verify',
              text: 'Look for the original source and another trusted one',
              isCorrect: true,
            ),
            AnswerOption(
              id: 'likes',
              text: 'Check if it has a lot of likes',
              isCorrect: false,
            ),
          ],
          explanation:
              'Popularity is not evidence. Identify the source and look for corroboration.',
        )
      : const UnifiedQuestion(
          id: 'offline_daily_source',
          type: QuestionType.quiz,
          title:
              'Una publicacion sorprendente no incluye autor ni fuente. ¿Que haces primero?',
          subtitle: 'Aplica PIENSA antes de compartir.',
          options: [
            AnswerOption(
              id: 'share',
              text: 'La comparto porque parece urgente',
              isCorrect: false,
            ),
            AnswerOption(
              id: 'verify',
              text: 'Busco la fuente original y otra fuente confiable',
              isCorrect: true,
            ),
            AnswerOption(
              id: 'likes',
              text: 'Reviso si tiene muchos me gusta',
              isCorrect: false,
            ),
          ],
          explanation:
              'La popularidad no es evidencia. Identifica la fuente y busca corroboracion.',
        );
}
