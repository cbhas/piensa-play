// lib/features/onboarding/domain/usecases/get_user_profile.dart

import '../entities/user_profile.dart';
import '../../data/repositories/onboarding_repository_impl.dart';

class GetUserProfile {
  final OnboardingRepositoryImpl _repository = OnboardingRepositoryImpl();

  Future<UserProfile?> execute() async {
    try {
      return await _repository.getUserProfile();
    } catch (e) {
      print('Error en GetUserProfile: $e');
      return null;
    }
  }
}
