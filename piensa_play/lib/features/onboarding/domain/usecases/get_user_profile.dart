// lib/features/onboarding/domain/usecases/get_user_profile.dart

import 'package:piensa_play/core/services/logger_service.dart';
import '../entities/user_profile.dart';
import '../../data/repositories/onboarding_repository_impl.dart';

class GetUserProfile {
  final OnboardingRepositoryImpl _repository = OnboardingRepositoryImpl();

  Future<UserProfile?> execute() async {
    try {
      return await _repository.getUserProfile();
    } catch (e) {
      AppLogger.error('Error en GetUserProfile: $e');
      return null;
    }
  }
}
