// lib/features/home/data/datasources/home_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/user_progress.dart';

class HomeRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Guardar DashboardStats en Firestore
  Future<void> saveDashboardStats(String userId, DashboardStats stats) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('stats')
          .set({
        'newGames': stats.newGames,
        'pendingGlossary': stats.pendingGlossary,
        'achievements': stats.achievements,
        'activeMissions': stats.activeMissions,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('✅ DashboardStats guardado en Firestore');
    } catch (e) {
      print('❌ Error guardando DashboardStats: $e');
      rethrow;
    }
  }

  // Obtener DashboardStats desde Firestore
  Future<DashboardStats?> getDashboardStats(String userId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('stats')
          .get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        return DashboardStats(
          newGames: data['newGames'] ?? 0,
          pendingGlossary: data['pendingGlossary'] ?? 0,
          achievements: data['achievements'] ?? 0,
          activeMissions: data['activeMissions'] ?? 0,
        );
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo DashboardStats: $e');
      return null;
    }
  }

  // Guardar UserProgress en Firestore
  Future<void> saveUserProgress(String userId, UserProgress progress) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('current')
          .set({
        'generalProgress': progress.generalProgress,
        'monthlyProgress': progress.monthlyProgress,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('✅ UserProgress guardado en Firestore');
    } catch (e) {
      print('❌ Error guardando UserProgress: $e');
      rethrow;
    }
  }

  // Obtener UserProgress desde Firestore
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('current')
          .get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        return UserProgress(
          generalProgress: (data['generalProgress'] as num?)?.toDouble() ?? 0.0,
          monthlyProgress: Map<String, double>.from(
            (data['monthlyProgress'] as Map?)?.map(
                  (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
            ) ??
                {},
          ),
        );
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo UserProgress: $e');
      return null;
    }
  }

  // Stream en tiempo real para cambios (Bonus)
  Stream<DashboardStats?> watchDashboardStats(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('dashboard')
        .doc('stats')
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = doc.data() ?? {};
        return DashboardStats(
          newGames: data['newGames'] ?? 0,
          pendingGlossary: data['pendingGlossary'] ?? 0,
          achievements: data['achievements'] ?? 0,
          activeMissions: data['activeMissions'] ?? 0,
        );
      }
      return null;
    });
  }
}
