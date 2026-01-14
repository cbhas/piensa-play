// lib/features/onboarding/domain/usecases/save_user_profile.dart

import 'package:piensa_play/core/services/logger_service.dart';
import '../entities/user_profile.dart';
import '../../data/repositories/onboarding_repository_impl.dart';

class SaveUserProfile {
  final OnboardingRepositoryImpl _repository = OnboardingRepositoryImpl();

  Future<void> execute(UserProfile profile) async {
    try {
      await _repository.saveUserProfile(profile);
      AppLogger.success(
        'SaveUserProfile ejecutado correctamente: ${profile.avatarId}',
      );
    } catch (e) {
      AppLogger.error('Error en SaveUserProfile: $e');
      rethrow;
    }
  }
}
