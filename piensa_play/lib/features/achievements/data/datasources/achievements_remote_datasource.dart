import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/badge.dart';
import '../../domain/entities/recent_activity.dart';

class AchievementsRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Guardar Achievement en Firestore
  Future<void> saveAchievements(String userId, Achievement achievement) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .set({
            'generalProgress': achievement.generalProgress,
            'currentLevel': achievement.currentLevel,
            'totalXP': achievement.totalXP,
            'coins': achievement.coins,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      print('✅ Achievement guardado en Firestore');
    } catch (e) {
      print('❌ Error guardando Achievement: $e');
      rethrow;
    }
  }

  // Obtener Achievement desde Firestore
  Future<Achievement?> getAchievements(String userId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('current')
          .get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        return Achievement(
          generalProgress: (data['generalProgress'] as num?)?.toDouble() ?? 0.0,
          currentLevel: data['currentLevel'] ?? 0,
          totalXP: data['totalXP'] ?? 0,
          coins: data['coins'] ?? 0,
        );
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo Achievement: $e');
      return null;
    }
  }

  // Guardar Badges en Firestore
  Future<void> saveBadges(String userId, List<Badge> badges) async {
    try {
      final batch = firestore.batch();
      final badgesRef = firestore
          .collection('users')
          .doc(userId)
          .collection('badges');

      for (var badge in badges) {
        batch.set(badgesRef.doc(badge.id), {
          'title': badge.title,
          'iconName': badge.iconName,
          'isUnlocked': badge.isUnlocked,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      print('✅ Badges guardados en Firestore');
    } catch (e) {
      print('❌ Error guardando Badges: $e');
      rethrow;
    }
  }

  // Obtener Badges desde Firestore
  Future<List<Badge>?> getBadges(String userId) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('badges')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Badge(
            id: doc.id,
            title: data['title'] ?? '',
            iconName: data['iconName'] ?? '',
            isUnlocked: data['isUnlocked'] ?? false,
          );
        }).toList();
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo Badges: $e');
      return null;
    }
  }

  // Guardar Recent Activities en Firestore
  Future<void> saveRecentActivities(
    String userId,
    List<RecentActivity> activities,
  ) async {
    try {
      final batch = firestore.batch();
      final activitiesRef = firestore
          .collection('users')
          .doc(userId)
          .collection('recent_activities');

      for (var activity in activities) {
        batch.set(activitiesRef.doc(activity.id), {
          'description': activity.description,
          'xpReward': activity.xpReward,
          'iconName': activity.iconName,
          'isCompleted': activity.isCompleted,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      print('✅ Recent Activities guardadas en Firestore');
    } catch (e) {
      print('❌ Error guardando Recent Activities: $e');
      rethrow;
    }
  }

  // Obtener Recent Activities desde Firestore
  Future<List<RecentActivity>?> getRecentActivities(String userId) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('recent_activities')
          .where('isCompleted', isEqualTo: true)
          .orderBy('lastUpdated', descending: true)
          .limit(10)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return RecentActivity(
            id: doc.id,
            description: data['description'] ?? '',
            xpReward: data['xpReward'] ?? 0,
            iconName: data['iconName'] ?? '',
            isCompleted: data['isCompleted'] ?? false,
          );
        }).toList();
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo Recent Activities: $e');
      return null;
    }
  }
}
