// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:piensa_play/core/services/logger_service.dart';

/// Service to handle Firebase Anonymous Authentication
/// This provides a unique user ID for each device without requiring login
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID (returns null if not signed in)
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get current user (returns null if not signed in)
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Sign in anonymously
  /// This creates a unique user ID that persists across app restarts
  /// but is lost if the app is uninstalled
  Future<String> signInAnonymously() async {
    try {
      AppLogger.log('AUTH: Signing in anonymously...');
      final userCredential = await _auth.signInAnonymously();
      final uid = userCredential.user!.uid;
      AppLogger.success('AUTH: Signed in anonymously with UID: $uid');
      return uid;
    } catch (e) {
      AppLogger.error('AUTH: Error signing in anonymously: $e');
      rethrow;
    }
  }

  /// Ensure user is signed in (sign in if not already)
  /// Call this on app startup to ensure we always have a user ID
  Future<String> ensureSignedIn() async {
    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      AppLogger.success('AUTH: Already signed in with UID: $uid');
      return uid;
    }

    return await signInAnonymously();
  }

  /// Sign out (useful for testing or resetting the app)
  Future<void> signOut() async {
    try {
      AppLogger.log('AUTH: Signing out...');
      await _auth.signOut();
      AppLogger.success('AUTH: Signed out successfully');
    } catch (e) {
      AppLogger.error('AUTH: Error signing out: $e');
      rethrow;
    }
  }

  /// Listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
