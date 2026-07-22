import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger_service.dart';
import 'user_id_provider.dart';

/// Recuperacion mediante una capsula de datos de alta entropia.
///
/// El codigo no expone el UID anterior, no permite listar cuentas, expira en
/// 30 dias y se elimina al utilizarlo. Regenerarlo invalida el anterior.
class RecoveryCodeService {
  static final RecoveryCodeService instance = RecoveryCodeService._();
  RecoveryCodeService._();

  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const _codeLength = 16;
  static const _subCollections = <String>[
    'profile',
    'achievements',
    'mission_progress',
    'daily_progress',
    'unlockedBadges',
    'purchased_items',
    'inventory',
    'recent_activities',
    'reward_claims',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateRandomCode() {
    final random = Random.secure();
    return List.generate(
      _codeLength,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }

  String _normalize(String code) =>
      code.toUpperCase().replaceAll(RegExp(r'[^A-Z2-9]'), '');

  Future<String?> getRecoveryCode() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(UserIdProvider.currentUserId)
          .collection('recovery')
          .doc('code')
          .get();
      final data = snapshot.data();
      final expiresAt = data?['expiresAt'] as Timestamp?;
      if (expiresAt != null && expiresAt.toDate().isBefore(DateTime.now())) {
        return null;
      }
      return data?['code'] as String?;
    } catch (error) {
      AppLogger.error('RECOVERY: code unavailable: $error');
      return null;
    }
  }

  Future<String?> generateAndSaveCode() async {
    final userId = UserIdProvider.currentUserId;
    try {
      final payload = await _createSnapshot(userId);
      final userCodeRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('recovery')
          .doc('code');
      final oldCode = (await userCodeRef.get()).data()?['code'] as String?;
      final expiresAt = DateTime.now().add(const Duration(days: 30));

      for (var attempt = 0; attempt < 6; attempt++) {
        final code = _generateRandomCode();
        final capsuleRef = _firestore.collection('recovery_capsules').doc(code);
        try {
          await _firestore.runTransaction((transaction) async {
            final existing = await transaction.get(capsuleRef);
            if (existing.exists) throw StateError('code-collision');

            transaction.set(capsuleRef, {
              'ownerId': userId,
              'data': payload,
              'createdAt': FieldValue.serverTimestamp(),
              'expiresAt': Timestamp.fromDate(expiresAt),
              'schemaVersion': 2,
            });
            transaction.set(userCodeRef, {
              'code': code,
              'createdAt': FieldValue.serverTimestamp(),
              'expiresAt': Timestamp.fromDate(expiresAt),
            });
            if (oldCode != null && oldCode != code) {
              transaction.delete(
                _firestore.collection('recovery_capsules').doc(oldCode),
              );
            }
          });
          return code;
        } on StateError {
          continue;
        }
      }
      return null;
    } catch (error) {
      AppLogger.error('RECOVERY: generation failed: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> findAccountByCode(String code) async {
    try {
      final normalized = _normalize(code);
      if (normalized.length != _codeLength) return null;
      final snapshot = await _firestore
          .collection('recovery_capsules')
          .doc(normalized)
          .get();
      if (!snapshot.exists) return null;
      final data = snapshot.data()!;
      final expiresAt = data['expiresAt'] as Timestamp?;
      if (expiresAt == null || expiresAt.toDate().isBefore(DateTime.now())) {
        return null;
      }

      final payload = Map<String, dynamic>.from(data['data'] as Map);
      final profileCollection = payload['profile'];
      Map<String, dynamic>? profile;
      if (profileCollection is Map && profileCollection['data'] is Map) {
        profile = Map<String, dynamic>.from(profileCollection['data'] as Map);
      }
      return {'profile': profile, 'expiresAt': expiresAt};
    } catch (error) {
      AppLogger.error('RECOVERY: lookup failed: $error');
      return null;
    }
  }

  Future<bool> recoverAccount(String code) async {
    final normalized = _normalize(code);
    if (normalized.length != _codeLength) return false;

    try {
      final capsuleRef = _firestore
          .collection('recovery_capsules')
          .doc(normalized);
      final capsule = await capsuleRef.get();
      if (!capsule.exists) return false;
      final capsuleData = capsule.data()!;
      final expiresAt = capsuleData['expiresAt'] as Timestamp?;
      if (expiresAt == null || expiresAt.toDate().isBefore(DateTime.now())) {
        return false;
      }

      final payload = Map<String, dynamic>.from(capsuleData['data'] as Map);
      final destination = _firestore
          .collection('users')
          .doc(UserIdProvider.currentUserId);
      final batch = _firestore.batch();
      var writes = 0;

      for (final collectionName in _subCollections) {
        final documents = payload[collectionName];
        if (documents is! Map) continue;
        for (final entry in documents.entries) {
          if (entry.value is! Map) continue;
          batch.set(
            destination.collection(collectionName).doc(entry.key.toString()),
            Map<String, dynamic>.from(entry.value as Map),
          );
          writes++;
        }
      }
      if (writes >= 450) {
        throw StateError('recovery-payload-too-large');
      }

      batch.delete(capsuleRef);
      await batch.commit();
      await _refreshLocalProfile(payload);
      return true;
    } catch (error) {
      AppLogger.error('RECOVERY: restore failed: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> _createSnapshot(String userId) async {
    final result = <String, dynamic>{};
    final userRef = _firestore.collection('users').doc(userId);
    for (final collectionName in _subCollections) {
      final snapshot = await userRef.collection(collectionName).get();
      result[collectionName] = {
        for (final document in snapshot.docs) document.id: document.data(),
      };
    }
    return result;
  }

  Future<void> _refreshLocalProfile(Map<String, dynamic> payload) async {
    final profileDocuments = payload['profile'];
    if (profileDocuments is! Map || profileDocuments['data'] is! Map) return;
    final profile = Map<String, dynamic>.from(profileDocuments['data'] as Map);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(profile));
  }
}
