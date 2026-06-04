import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/firestore_provider.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'user_id_provider.dart';

/// Servicio para gestionar códigos de recuperación de cuenta
class RecoveryCodeService {
  static final RecoveryCodeService instance = RecoveryCodeService._();
  RecoveryCodeService._();

  final FirebaseFirestore _firestore = FirestoreProvider.instance;

  /// Caracteres permitidos en el código (sin O, 0, I, 1 para evitar confusión)
  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Genera un código aleatorio de 8 caracteres
  String _generateRandomCode() {
    final random = Random.secure();
    return List.generate(
      8,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }

  /// Obtiene el código de recuperación actual del usuario
  Future<String?> getRecoveryCode() async {
    try {
      final userId = UserIdProvider.currentUserId;
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('recovery')
          .doc('code')
          .get();

      if (doc.exists) {
        return doc.data()?['code'] as String?;
      }
      return null;
    } catch (e) {
      AppLogger.error('RECOVERY: Error getting code: $e');
      return null;
    }
  }

  /// Genera y guarda un nuevo código de recuperación
  Future<String?> generateAndSaveCode() async {
    try {
      final userId = UserIdProvider.currentUserId;
      final code = _generateRandomCode();

      // Guardar en el perfil del usuario
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('recovery')
          .doc('code')
          .set({'code': code, 'createdAt': FieldValue.serverTimestamp()});

      // Guardar índice inverso para búsqueda por código
      await _firestore.collection('recovery_codes').doc(code).set({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('RECOVERY: Code generated: $code');
      return code;
    } catch (e) {
      AppLogger.error('RECOVERY: Error generating code: $e');
      return null;
    }
  }

  /// Busca una cuenta por código de recuperación
  Future<Map<String, dynamic>?> findAccountByCode(String code) async {
    try {
      final codeDoc = await _firestore
          .collection('recovery_codes')
          .doc(code.toUpperCase())
          .get();

      if (!codeDoc.exists) {
        AppLogger.warning('RECOVERY: Code not found: $code');
        return null;
      }

      final originalUserId = codeDoc.data()?['userId'] as String?;
      if (originalUserId == null) return null;

      // Obtener perfil del usuario original
      final profileDoc = await _firestore
          .collection('users')
          .doc(originalUserId)
          .collection('profile')
          .doc('data')
          .get();

      if (profileDoc.exists) {
        return {'userId': originalUserId, 'profile': profileDoc.data()};
      }

      return {'userId': originalUserId};
    } catch (e) {
      AppLogger.error('RECOVERY: Error finding account: $e');
      return null;
    }
  }

  /// Vincula la cuenta actual con el userId de la cuenta a recuperar
  /// (Copia todos los datos del usuario original al nuevo)
  Future<bool> recoverAccount(String code) async {
    try {
      final accountData = await findAccountByCode(code);
      if (accountData == null) return false;

      final originalUserId = accountData['userId'] as String;
      final currentUserId = UserIdProvider.currentUserId;

      if (originalUserId == currentUserId) {
        AppLogger.warning('RECOVERY: Same account, no transfer needed');
        return true;
      }

      // Copiar subcolecciones del usuario original al actual
      await _copyUserData(originalUserId, currentUserId);

      AppLogger.success('RECOVERY: Account recovered successfully');
      return true;
    } catch (e) {
      AppLogger.error('RECOVERY: Error recovering account: $e');
      return false;
    }
  }

  /// Copia los datos de un usuario a otro
  Future<void> _copyUserData(String fromUserId, String toUserId) async {
    final subCollections = [
      'profile',
      'achievements',
      'mission_progress',
      'daily_progress',
    ];

    for (final subCollection in subCollections) {
      final docs = await _firestore
          .collection('users')
          .doc(fromUserId)
          .collection(subCollection)
          .get();

      for (final doc in docs.docs) {
        await _firestore
            .collection('users')
            .doc(toUserId)
            .collection(subCollection)
            .doc(doc.id)
            .set(doc.data());
      }
      AppLogger.log('RECOVERY: Copied $subCollection');
    }
  }
}
