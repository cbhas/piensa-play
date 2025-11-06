// ============================================
// lib/features/onboarding/domain/usecases/save_user_profile.dart
// ============================================

import '../entities/user_profile.dart';

class SaveUserProfile {
  Future<void> execute(UserProfile profile) async {
    // Implementación de guardado local/Firebase
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
