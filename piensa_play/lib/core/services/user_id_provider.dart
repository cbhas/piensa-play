import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

/// Identidad estable para el modo sin conexion.
///
/// Nunca usa un identificador global compartido. Cuando Firebase Auth esta
/// disponible se utiliza su UID; en una primera apertura offline se conserva
/// un ID aleatorio exclusivo de esta instalacion.
class UserIdProvider {
  static const _offlineIdKey = 'offline_installation_id';
  static final AuthService _authService = AuthService();
  static String? _offlineId;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _offlineId = prefs.getString(_offlineIdKey);
    if (_offlineId != null) return;

    final random = Random.secure();
    final bytes = List<int>.generate(20, (_) => random.nextInt(256));
    _offlineId =
        'offline_${bytes.map((value) => value.toRadixString(16).padLeft(2, '0')).join()}';
    await prefs.setString(_offlineIdKey, _offlineId!);
  }

  static String get currentUserId {
    final firebaseId = _authService.currentUserId;
    if (firebaseId != null) return firebaseId;
    final offlineId = _offlineId;
    if (offlineId == null) {
      throw StateError('UserIdProvider.initialize() must run before the app');
    }
    return offlineId;
  }

  static bool get isUsingFirebaseUid => _authService.currentUserId != null;
}
