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

  // Guardar Badges desbloqueados en Firestore (solo IDs)
  Future<void> saveBadges(String userId, List<Badge> badges) async {
    try {
      print('🔵 BADGES: Saving unlocked badges for user $userId');

      final batch = firestore.batch();
      final unlockedBadgesRef = firestore
          .collection('users')
          .doc(userId)
          .collection('unlockedBadges');

      // Solo guardar los badges que están desbloqueados
      final unlockedBadges = badges.where((badge) => badge.isUnlocked).toList();

      print('🟡 BADGES: Saving ${unlockedBadges.length} unlocked badges');

      for (var badge in unlockedBadges) {
        batch.set(unlockedBadgesRef.doc(badge.id), {
          'unlockedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      print('✅ Badges desbloqueados guardados en Firestore');
    } catch (e) {
      print('❌ Error guardando Badges: $e');
      rethrow;
    }
  }

  // Obtener Badges desde Firestore (nueva estructura)
  Future<List<Badge>?> getBadges(String userId) async {
    try {
      print('🔵 BADGES: Loading from global collection...');

      // 1. Cargar todos los badges desde la colección global
      final badgesSnapshot = await firestore
          .collection('badges')
          .orderBy('order')
          .get();

      if (badgesSnapshot.docs.isEmpty) {
        print('⚠️ BADGES: No badges found in global collection');
        return null;
      }

      // 2. Cargar badges desbloqueados del usuario
      final unlockedSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('unlockedBadges')
          .get();

      final unlockedIds = unlockedSnapshot.docs.map((doc) => doc.id).toSet();
      print('🟡 BADGES: User has ${unlockedIds.length} unlocked badges');

      // 3. Combinar: marcar como desbloqueados los que tiene el usuario
      final badges = badgesSnapshot.docs.map((doc) {
        final data = doc.data();
        final isUnlocked = unlockedIds.contains(doc.id);

        return Badge(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'],
          iconName: data['iconName'] ?? '',
          isUnlocked: isUnlocked,
        );
      }).toList();

      print('🟢 BADGES: Loaded ${badges.length} badges total');
      return badges;
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
