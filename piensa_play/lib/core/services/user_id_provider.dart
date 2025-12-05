// lib/core/services/user_id_provider.dart

import 'auth_service.dart';

/// Helper to get the current user ID
/// Returns the Firebase UID if signed in, otherwise returns a fallback ID
class UserIdProvider {
  static final AuthService _authService = AuthService();

  /// Get current user ID
  /// Returns Firebase UID or 'user123' as fallback
  static String get currentUserId {
    return _authService.currentUserId ?? 'user123';
  }

  /// Check if using real Firebase UID (not fallback)
  static bool get isUsingFirebaseUid {
    return _authService.currentUserId != null;
  }
}
