// lib/features/onboarding/domain/usecases/save_user_profile.dart

import '../entities/user_profile.dart';
import '../../data/repositories/onboarding_repository_impl.dart';

class SaveUserProfile {
  final OnboardingRepositoryImpl _repository = OnboardingRepositoryImpl();

  Future<void> execute(UserProfile profile) async {
    try {
      await _repository.saveUserProfile(profile);
      print('✅ SaveUserProfile ejecutado correctamente: ${profile.avatarId}');
    } catch (e) {
      print('❌ Error en SaveUserProfile: $e');
      rethrow;
    }
  }
}
