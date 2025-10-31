import 'package:piensa_play/core/constants/app_constants.dart';
import 'package:piensa_play/features/welcome/domain/entities/welcome_config.dart';

class GetWelcomeConfig {
  WelcomeConfig execute() {
    return const WelcomeConfig(
      title: AppConstants.welcomeTitle,
      subtitle: AppConstants.welcomeSubtitle,
      startButtonLabel: AppConstants.startButton,
      tutorialButtonLabel: AppConstants.tutorialButton,
      currentLanguage: AppConstants.languageLabel,
    );
  }
}