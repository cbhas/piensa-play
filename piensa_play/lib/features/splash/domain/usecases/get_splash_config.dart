import 'package:piensa_play/core/constants/app_constants.dart';
import 'package:piensa_play/features/splash/domain/entities/splash_config.dart';

class GetSplashConfig {
  SplashConfig execute() {
    return const SplashConfig(
      appName: AppConstants.appName,
      mascot: AppConstants.mascotEmoji,
      durationSeconds: AppConstants.splashDuration,
    );
  }
}