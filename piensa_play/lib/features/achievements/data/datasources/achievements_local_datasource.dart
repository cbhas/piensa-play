import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/badge.dart';
import '../../domain/entities/recent_activity.dart';

class AchievementsLocalDatasource {
  // Guardar Achievement
  Future<void> saveAchievements(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('achievements', jsonEncode(achievement.toJson()));
  }

  // Obtener Achievement
  Future<Achievement> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('achievements');
    if (jsonString != null) {
      return Achievement.fromJson(jsonDecode(jsonString));
    }
    // Valores por defecto para nuevo usuario
    final defaultAchievement = Achievement.initial();
    await saveAchievements(defaultAchievement);
    return defaultAchievement;
  }

  // Guardar Badges
  Future<void> saveBadges(List<Badge> badges) async {
    final prefs = await SharedPreferences.getInstance();
    final badgesJson = badges.map((b) => b.toJson()).toList();
    await prefs.setString('badges', jsonEncode(badgesJson));
  }

  // Obtener Badges
  Future<List<Badge>> getBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('badges');
    if (jsonString != null) {
      final List<dynamic> badgesJson = jsonDecode(jsonString);
      return badgesJson.map((json) => Badge.fromJson(json)).toList();
    }
    // Nuevo usuario: no tiene badges desbloqueados
    // Los badges vendrán de Firebase, todos locked por defecto
    final defaultBadges = <Badge>[
      const Badge(
        id: 'investigador_junior',
        title: 'Investigador\nJunior',
        iconName: 'search',
        isUnlocked: false,
      ),
      const Badge(
        id: 'maestro_contrasenas',
        title: 'Maestro\nde Contraseñas',
        iconName: 'lock',
        isUnlocked: false,
      ),
      const Badge(
        id: 'guardian_digital',
        title: 'Guardian Digital',
        iconName: 'shield',
        isUnlocked: false,
      ),
      const Badge(
        id: 'detector_spam',
        title: 'Detector\nde Spam',
        iconName: 'flag',
        isUnlocked: false,
      ),
      const Badge(
        id: 'navegante_experto',
        title: 'Navegante\nExperto',
        iconName: 'explore',
        isUnlocked: false,
      ),
    ];
    // No guardamos por defecto, dejamos que Firebase sea la fuente de verdad
    return defaultBadges;
  }

  // Guardar Recent Activities
  Future<void> saveRecentActivities(List<RecentActivity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = activities.map((a) => a.toJson()).toList();
    await prefs.setString('recent_activities', jsonEncode(activitiesJson));
  }

  // Obtener Recent Activities
  Future<List<RecentActivity>> getRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('recent_activities');
    if (jsonString != null) {
      final List<dynamic> activitiesJson = jsonDecode(jsonString);
      return activitiesJson
          .map((json) => RecentActivity.fromJson(json))
          .toList();
    }
    // Valores por defecto (mock data basado en la imagen)
    final defaultActivities = [
      const RecentActivity(
        id: 'activity_1',
        description: 'Crea una contraseña\nsegura',
        xpReward: 50,
        iconName: 'lock',
        isCompleted: true,
      ),
      const RecentActivity(
        id: 'activity_2',
        description: 'Detector de Fake\nNews',
        xpReward: 75,
        iconName: 'play_circle',
        isCompleted: true,
      ),
    ];
    await saveRecentActivities(defaultActivities);
    return defaultActivities;
  }
}
