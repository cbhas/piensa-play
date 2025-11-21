import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/user_progress.dart';

class HomeLocalDatasource {
  Future<void> saveDashboardStats(DashboardStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashboard_stats', jsonEncode(stats.toJson()));
  }

  Future<DashboardStats> getDashboardStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('dashboard_stats');
    if (jsonString != null) {
      return DashboardStats.fromJson(jsonDecode(jsonString));
    }
    // Valores por defecto
    final defaultStats = const DashboardStats(
      newGames: 0,
      pendingGlossary: 0,
      achievements: 0,
      activeMissions: 0,
    );
    await saveDashboardStats(defaultStats);
    return defaultStats;
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_progress', jsonEncode(progress.toJson()));
  }

  Future<UserProgress> getUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_progress');
    if (jsonString != null) {
      return UserProgress.fromJson(jsonDecode(jsonString));
    }
    // Valores por defecto
    final defaultProgress = const UserProgress(
      generalProgress: 0.0,
      monthlyProgress: {},
    );
    await saveUserProgress(defaultProgress);
    return defaultProgress;
  }
}
