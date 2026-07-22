import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/reward_policy.dart';
import '../../features/achievements/domain/entities/achievement.dart';
import '../../features/missions/domain/entities/unified_question.dart';
import 'app_data_service.dart';
import 'logger_service.dart';
import 'user_id_provider.dart';
import 'widget_service.dart';

/// Pregunta diaria estable e idempotente.
class DailyQuestionService {
  static final DailyQuestionService _instance =
      DailyQuestionService._internal();
  factory DailyQuestionService() => _instance;
  DailyQuestionService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UnifiedQuestion? _todaysQuestion;
  DateTime? _lastFetchDate;

  String get _todayString => _dateString(DateTime.now());

  String _dateString(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

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

  Future<UnifiedQuestion?> getTodaysQuestion() async {
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
      if (snapshot.docs.isEmpty) return _offlineQuestion;

      final selected = snapshot.docs[_getDailyIndex(snapshot.docs.length)];
      _todaysQuestion = UnifiedQuestion.fromJson({
        'id': selected.id,
        ...selected.data(),
      });
      _lastFetchDate = now;
      return _todaysQuestion;
    } catch (error) {
      AppLogger.warning('DAILY: using offline question: $error');
      _todaysQuestion = _offlineQuestion;
      _lastFetchDate = now;
      return _todaysQuestion;
    }
  }

  /// Actualiza progreso y monedas en una sola transaccion. Una segunda llamada
  /// el mismo dia devuelve cero y no altera contadores.
  Future<Map<String, int>> submitAnswer(bool isCorrect) async {
    final userId = UserIdProvider.currentUserId;
    final progressRef = _dailyProgressRef(userId);
    final achievementRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .doc('current');

    var xpAwarded = 0;
    var coinsAwarded = 0;
    var streak = 0;
    var bestStreak = 0;
    var totalAnswered = 0;
    var updatedAchievement = Achievement.initial();

    try {
      await _firestore.runTransaction((transaction) async {
        final progressSnapshot = await transaction.get(progressRef);
        final achievementSnapshot = await transaction.get(achievementRef);
        final progress = progressSnapshot.data() ?? const <String, dynamic>{};

        updatedAchievement = achievementSnapshot.exists
            ? Achievement.fromJson(achievementSnapshot.data()!)
            : Achievement.initial();

        final yesterday = _dateString(
          DateTime.now().subtract(const Duration(days: 1)),
        );
        final decision = DailyRewardPolicy.decide(
          isCorrect: isCorrect,
          today: _todayString,
          yesterday: yesterday,
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
        try {
          await WidgetService().markAsCompleted(streak);
        } catch (error) {
          AppLogger.warning('DAILY: widget update skipped: $error');
        }
      }

      return {
        'xp': xpAwarded,
        'coins': coinsAwarded,
        'streak': streak,
        'totalXP': updatedAchievement.totalXP,
        'totalCoins': updatedAchievement.coins,
      };
    } catch (error) {
      AppLogger.error('DAILY: atomic answer failed: $error');
      return {'xp': 0, 'coins': 0, 'streak': 0};
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

  UnifiedQuestion get _offlineQuestion => const UnifiedQuestion(
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
