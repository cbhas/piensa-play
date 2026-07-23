import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/firestore_provider.dart';
import 'package:piensa_play/features/missions/domain/entities/mission_category.dart';
import 'package:piensa_play/features/missions/domain/usecases/get_mission_categories.dart';
import 'package:piensa_play/features/achievements/domain/entities/achievement.dart';
import 'package:piensa_play/features/achievements/domain/entities/badge.dart';
import 'package:piensa_play/features/achievements/data/repositories/achievements_repository_impl.dart';
import 'package:piensa_play/features/glossary/domain/entities/glossary_term.dart';
import 'package:piensa_play/features/glossary/domain/usecases/get_glossary_terms.dart';
import 'package:piensa_play/features/onboarding/domain/entities/user_profile.dart';
import 'package:piensa_play/features/onboarding/domain/usecases/get_user_profile.dart';
import 'package:piensa_play/features/home/domain/entities/dashboard_stats.dart';
import 'package:piensa_play/features/home/domain/entities/user_progress.dart';
import 'package:piensa_play/features/home/domain/usecases/get_dashboard_stats.dart';
import 'package:piensa_play/features/home/domain/usecases/get_user_progress.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/features/shop/domain/entities/shop_item.dart';
import 'package:piensa_play/core/services/unified_questions_service.dart';
import 'package:piensa_play/features/missions/domain/entities/unified_question.dart';
import 'user_id_provider.dart';

/// Singleton service that manages all app data.
/// Loads data once at app startup and provides cached access.
class AppDataService {
  // Private constructor for singleton
  AppDataService._();

  // Singleton instance
  static final AppDataService _instance = AppDataService._();
  static AppDataService get instance => _instance;

  // Use cases
  final GetMissionCategories _getMissionCategories = GetMissionCategories();
  final AchievementsRepositoryImpl _achievementsRepo =
      AchievementsRepositoryImpl();
  final GetGlossaryTerms _getGlossaryTerms = GetGlossaryTerms();
  final GetUserProfile _getUserProfile = GetUserProfile();
  final GetDashboardStats _getDashboardStats = GetDashboardStats();
  final GetUserProgress _getUserProgress = GetUserProgress();

  // Cached data
  List<MissionCategory>? _missionCategories;
  Achievement? _achievement;
  List<Badge>? _badges;
  List<GlossaryTerm>? _glossaryTerms;
  UserProfile? _userProfile;
  DashboardStats? _dashboardStats;
  UserProgress? _userProgress;

  // Shop cache
  List<ShopItem>? _shopItems;
  Set<String>? _purchasedItemIds;
  int _streakFreezeCount = 0;

  // Daily progress cache
  int _dailyStreak = 0;
  int _dailyBestStreak = 0;
  int _dailyTotalAnswered = 0;
  int _dailyTotalCorrect = 0;
  String? _dailyLastAnsweredDate;

  // Questions cache (missionId -> questions)
  Map<String, List<UnifiedQuestion>>? _questionsByMission;

  // Loading state
  bool _isLoading = false;
  bool _isLoaded = false;

  // Getters for cached data
  List<MissionCategory> get missionCategories => _missionCategories ?? [];
  Achievement get achievement => _achievement ?? Achievement.initial();
  List<Badge> get badges => _badges ?? [];
  List<GlossaryTerm> get glossaryTerms => _glossaryTerms ?? [];
  UserProfile? get userProfile => _userProfile;
  DashboardStats? get dashboardStats => _dashboardStats;
  UserProgress? get userProgress => _userProgress;

  // Shop getters
  List<ShopItem> get shopItems => _shopItems ?? [];
  Set<String> get purchasedItemIds => _purchasedItemIds ?? {};
  int get streakFreezeCount => _streakFreezeCount;

  // Daily progress getters
  int get dailyStreak => _dailyStreak;
  int get dailyBestStreak => _dailyBestStreak;
  int get dailyTotalAnswered => _dailyTotalAnswered;
  int get dailyTotalCorrect => _dailyTotalCorrect;

  /// Última fecha respondida (`yyyy-MM-dd`), o null si nunca respondió.
  ///
  /// La expone la caché porque sin conexión no siempre se puede leer de
  /// Firestore: `get()` lanza `unavailable` cuando el documento nunca estuvo
  /// en la caché local. Es el dato que permite decidir la racha y la
  /// idempotencia de la pregunta diaria estando offline.
  String? get dailyLastAnsweredDate => _dailyLastAnsweredDate;

  /// Get questions for a specific mission (from memory, instant)
  List<UnifiedQuestion> getQuestionsForMission(String missionId) {
    return _questionsByMission?[missionId] ?? [];
  }

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  String get _userId => UserIdProvider.currentUserId;

  /// Load all app data at once (called during splash screen)
  Future<void> loadAllData() async {
    if (_isLoading) return;
    _isLoading = true;

    AppLogger.log('APP DATA SERVICE: Loading all data...');

    try {
      // Load all data in parallel for speed
      await Future.wait([
        _loadMissions(),
        _loadAchievements(),
        _loadGlossary(),
        _loadProfile(),
        _loadDashboard(),
        _loadDailyProgress(),
        _loadShopItems(),
        _loadQuestions(), // Load questions into memory
      ]);

      _isLoaded = true;
      AppLogger.success('APP DATA SERVICE: All data loaded successfully');
    } catch (e) {
      AppLogger.error('APP DATA SERVICE: Error loading data: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Refresh a specific section of data
  Future<void> refreshMissions() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing missions...');
    await _loadMissions();
  }

  Future<void> refreshAchievements() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing achievements...');
    await _loadAchievements();
  }

  Future<void> refreshGlossary() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing glossary...');
    await _loadGlossary();
  }

  Future<void> refreshProfile() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing profile...');
    await _loadProfile();
  }

  Future<void> refreshDashboard() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing dashboard...');
    await _loadDashboard();
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing all data...');
    await loadAllData();
  }

  // Private loading methods
  Future<void> _loadMissions() async {
    try {
      _missionCategories = await _getMissionCategories.execute(_userId);
      AppLogger.success(
        'Missions loaded: ${_missionCategories?.length ?? 0} categories',
      );
    } catch (e) {
      AppLogger.warning('Failed to load missions: $e');
    }
  }

  Future<void> _loadAchievements() async {
    try {
      _achievement = await _achievementsRepo.getAchievements(_userId);
      _badges = await _achievementsRepo.getBadges(_userId);
      AppLogger.success(
        'Achievements loaded: Level ${_achievement?.currentLevel}, ${_badges?.length ?? 0} badges',
      );
    } catch (e) {
      AppLogger.warning('Failed to load achievements: $e');
    }
  }

  Future<void> _loadGlossary() async {
    try {
      _glossaryTerms = await _getGlossaryTerms.execute(_userId);
      AppLogger.success(
        'Glossary loaded: ${_glossaryTerms?.length ?? 0} terms',
      );
    } catch (e) {
      AppLogger.warning('Failed to load glossary: $e');
    }
  }

  Future<void> _loadProfile() async {
    try {
      _userProfile = await _getUserProfile.execute();
      AppLogger.success('Profile loaded: ${_userProfile?.name}');
    } catch (e) {
      AppLogger.warning('Failed to load profile: $e');
    }
  }

  Future<void> _loadDashboard() async {
    try {
      _dashboardStats = await _getDashboardStats.execute(_userId);
      _userProgress = await _getUserProgress.execute(_userId);
      AppLogger.success('Dashboard loaded');
    } catch (e) {
      AppLogger.warning('Failed to load dashboard: $e');
    }
  }

  Future<void> _loadDailyProgress() async {
    try {
      final doc = await FirestoreProvider.instance
          .collection('users')
          .doc(_userId)
          .collection('daily_progress')
          .doc('current')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _dailyStreak = data['streak'] ?? 0;
        _dailyBestStreak = data['bestStreak'] ?? 0;
        _dailyTotalAnswered = data['totalAnswered'] ?? 0;
        _dailyTotalCorrect = data['totalCorrect'] ?? 0;

        final lastAnsweredDate = data['lastAnsweredDate'] as String?;
        _dailyLastAnsweredDate = lastAnsweredDate;

        // Verificar si la racha debe perderse
        if (_dailyStreak > 0 && lastAnsweredDate != null) {
          final shouldResetStreak = await _checkAndHandleStreakReset(
            lastAnsweredDate,
          );
          if (shouldResetStreak) {
            _dailyStreak = 0;
          }
        }

        AppLogger.success('Daily progress loaded - streak: $_dailyStreak');
      }
    } catch (e) {
      AppLogger.warning('Failed to load daily progress: $e');
    }
  }

  /// Verifica si la racha debe resetearse
  /// Retorna true si se debe resetear, false si se protegió con freeze streak
  Future<bool> _checkAndHandleStreakReset(String lastAnsweredDate) async {
    final now = DateTime.now();
    final todayString =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayString =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    // Si respondió hoy o ayer, la racha está bien
    if (lastAnsweredDate == todayString ||
        lastAnsweredDate == yesterdayString) {
      return false;
    }

    // La racha debería perderse, verificar si hay freeze streak disponible
    AppLogger.warning(
      'STREAK: Missed day(s). Last answered: $lastAnsweredDate',
    );

    try {
      // Verificar freeze streak en inventario
      final freezeDoc = await FirestoreProvider.instance
          .collection('users')
          .doc(_userId)
          .collection('inventory')
          .doc('streak_freeze')
          .get();

      final freezeCount = freezeDoc.data()?['count'] ?? 0;

      if (freezeCount > 0) {
        // Usar freeze streak para proteger la racha
        await FirestoreProvider.instance
            .collection('users')
            .doc(_userId)
            .collection('inventory')
            .doc('streak_freeze')
            .update({'count': FieldValue.increment(-1)});

        // Actualizar lastAnsweredDate para mantener la racha
        await FirestoreProvider.instance
            .collection('users')
            .doc(_userId)
            .collection('daily_progress')
            .doc('current')
            .update({'lastAnsweredDate': yesterdayString});

        // Mantener la caché en memoria sincronizada con Firestore
        _streakFreezeCount = freezeCount - 1;

        AppLogger.success(
          'STREAK: Used freeze streak to protect streak! Remaining: ${freezeCount - 1}',
        );
        return false; // Racha protegida
      }
    } catch (e) {
      AppLogger.error('STREAK: Error checking freeze streak: $e');
    }

    // No hay freeze streak, resetear la racha
    AppLogger.warning('STREAK: No freeze streak available, resetting streak');

    await FirestoreProvider.instance
        .collection('users')
        .doc(_userId)
        .collection('daily_progress')
        .doc('current')
        .update({'streak': 0});

    return true; // Debe resetearse
  }

  /// Update cached achievements (after completing a mission)
  void updateAchievement(Achievement newAchievement) {
    _achievement = newAchievement;
  }

  /// Actualiza el perfil cacheado despues de editar nombre o avatar.
  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
  }

  /// Update cached badges (after unlocking a badge)
  void updateBadges(List<Badge> newBadges) {
    _badges = newBadges;
  }

  /// Load shop items from Firestore
  Future<void> _loadShopItems() async {
    try {
      // Load items catalog
      final snapshot = await FirestoreProvider.instance
          .collection('shop_items')
          .orderBy('price')
          .get();

      // Load purchased items
      final purchasedSnapshot = await FirestoreProvider.instance
          .collection('users')
          .doc(_userId)
          .collection('purchased_items')
          .get();

      _purchasedItemIds = purchasedSnapshot.docs.map((d) => d.id).toSet();

      // Load streak freeze count
      final freezeDoc = await FirestoreProvider.instance
          .collection('users')
          .doc(_userId)
          .collection('inventory')
          .doc('streak_freeze')
          .get();

      _streakFreezeCount = freezeDoc.data()?['count'] ?? 0;

      // Map shop items with purchased status
      _shopItems = snapshot.docs.map((doc) {
        final item = ShopItem.fromJson({'id': doc.id, ...doc.data()});
        return item.copyWith(isPurchased: _purchasedItemIds!.contains(item.id));
      }).toList();

      AppLogger.success('Shop items loaded: ${_shopItems?.length ?? 0} items');
    } catch (e) {
      AppLogger.warning('Failed to load shop items: $e');
      _shopItems = [];
    }
  }

  /// Load all questions into memory (called during splash)
  Future<void> _loadQuestions() async {
    try {
      final questionsService = UnifiedQuestionsService();
      _questionsByMission = await questionsService.getAllQuestions();
      AppLogger.success(
        'Questions loaded: ${_questionsByMission?.length ?? 0} missions cached',
      );
    } catch (e) {
      AppLogger.warning('Failed to load questions: $e');
      _questionsByMission = {};
    }
  }

  /// Refresh shop items from Firestore
  Future<void> refreshShop() async {
    AppLogger.refresh('APP DATA SERVICE: Refreshing shop...');
    await _loadShopItems();
  }

  /// Mark item as purchased in cache
  void markItemAsPurchased(String itemId) {
    _purchasedItemIds?.add(itemId);
    if (_shopItems != null) {
      final index = _shopItems!.indexWhere((i) => i.id == itemId);
      if (index != -1) {
        _shopItems![index] = _shopItems![index].copyWith(isPurchased: true);
      }
    }
  }

  /// Update streak freeze count in cache
  void updateStreakFreezeCount(int count) {
    _streakFreezeCount = count;
  }

  /// Update a single badge as unlocked
  void unlockBadge(String badgeId) {
    if (_badges != null) {
      final index = _badges!.indexWhere((b) => b.id == badgeId);
      if (index != -1) {
        _badges![index] = Badge(
          id: _badges![index].id,
          title: _badges![index].title,
          description: _badges![index].description,
          iconName: _badges![index].iconName,
          isUnlocked: true,
        );
      }
    }
  }

  /// Mark a mission as completed in the cache (no Firebase call)
  void markMissionCompleted(String missionId) {
    if (_missionCategories == null) return;

    for (int i = 0; i < _missionCategories!.length; i++) {
      final category = _missionCategories![i];
      final missionIndex = category.missions.indexWhere(
        (m) => m.id == missionId,
      );

      if (missionIndex != -1) {
        // Crear nueva lista de misiones con la misión actualizada
        final updatedMissions = category.missions.map((m) {
          if (m.id == missionId) {
            return m.copyWith(isCompleted: true);
          }
          return m;
        }).toList();

        // Actualizar la categoría con las misiones actualizadas
        _missionCategories![i] = MissionCategory(
          id: category.id,
          title: category.title,
          description: category.description,
          iconName: category.iconName,
          colorHex: category.colorHex,
          missions: updatedMissions,
          isExpanded: category.isExpanded,
        );

        AppLogger.success('CACHE: Mission $missionId marked as completed');
        return;
      }
    }
  }

  /// Update daily progress cache (streak, best streak, total answered)
  void updateDailyProgress({
    required int streak,
    required int bestStreak,
    required int totalAnswered,
    int? totalCorrect,
    String? lastAnsweredDate,
  }) {
    _dailyStreak = streak;
    _dailyBestStreak = bestStreak;
    _dailyTotalAnswered = totalAnswered;
    if (totalCorrect != null) _dailyTotalCorrect = totalCorrect;
    if (lastAnsweredDate != null) _dailyLastAnsweredDate = lastAnsweredDate;
    AppLogger.success('CACHE: Daily progress updated - streak: $streak');
  }
}
