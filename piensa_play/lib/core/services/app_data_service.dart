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

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  String get _userId => UserIdProvider.currentUserId;

  /// Load all app data at once (called during splash screen)
  Future<void> loadAllData() async {
    if (_isLoading) return;
    _isLoading = true;

    print('🔵 APP DATA SERVICE: Loading all data...');

    try {
      // Load all data in parallel for speed
      await Future.wait([
        _loadMissions(),
        _loadAchievements(),
        _loadGlossary(),
        _loadProfile(),
        _loadDashboard(),
      ]);

      _isLoaded = true;
      print('🟢 APP DATA SERVICE: All data loaded successfully');
    } catch (e) {
      print('❌ APP DATA SERVICE: Error loading data: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Refresh a specific section of data
  Future<void> refreshMissions() async {
    print('🔄 APP DATA SERVICE: Refreshing missions...');
    await _loadMissions();
  }

  Future<void> refreshAchievements() async {
    print('🔄 APP DATA SERVICE: Refreshing achievements...');
    await _loadAchievements();
  }

  Future<void> refreshGlossary() async {
    print('🔄 APP DATA SERVICE: Refreshing glossary...');
    await _loadGlossary();
  }

  Future<void> refreshProfile() async {
    print('🔄 APP DATA SERVICE: Refreshing profile...');
    await _loadProfile();
  }

  Future<void> refreshDashboard() async {
    print('🔄 APP DATA SERVICE: Refreshing dashboard...');
    await _loadDashboard();
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    print('🔄 APP DATA SERVICE: Refreshing all data...');
    await loadAllData();
  }

  // Private loading methods
  Future<void> _loadMissions() async {
    try {
      _missionCategories = await _getMissionCategories.execute(_userId);
      print('✅ Missions loaded: ${_missionCategories?.length ?? 0} categories');
    } catch (e) {
      print('⚠️ Failed to load missions: $e');
    }
  }

  Future<void> _loadAchievements() async {
    try {
      _achievement = await _achievementsRepo.getAchievements(_userId);
      _badges = await _achievementsRepo.getBadges(_userId);
      print(
        '✅ Achievements loaded: Level ${_achievement?.currentLevel}, ${_badges?.length ?? 0} badges',
      );
    } catch (e) {
      print('⚠️ Failed to load achievements: $e');
    }
  }

  Future<void> _loadGlossary() async {
    try {
      _glossaryTerms = await _getGlossaryTerms.execute(_userId);
      print('✅ Glossary loaded: ${_glossaryTerms?.length ?? 0} terms');
    } catch (e) {
      print('⚠️ Failed to load glossary: $e');
    }
  }

  Future<void> _loadProfile() async {
    try {
      _userProfile = await _getUserProfile.execute();
      print('✅ Profile loaded: ${_userProfile?.name}');
    } catch (e) {
      print('⚠️ Failed to load profile: $e');
    }
  }

  Future<void> _loadDashboard() async {
    try {
      _dashboardStats = await _getDashboardStats.execute(_userId);
      _userProgress = await _getUserProgress.execute(_userId);
      print('✅ Dashboard loaded');
    } catch (e) {
      print('⚠️ Failed to load dashboard: $e');
    }
  }

  /// Update cached achievements (after completing a mission)
  void updateAchievement(Achievement newAchievement) {
    _achievement = newAchievement;
  }

  /// Update cached badges (after unlocking a badge)
  void updateBadges(List<Badge> newBadges) {
    _badges = newBadges;
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
}
