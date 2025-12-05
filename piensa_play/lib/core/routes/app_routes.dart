import 'package:flutter/material.dart';
import 'package:piensa_play/features/splash/presentation/pages/splash_page.dart';
import 'package:piensa_play/features/welcome/presentation/pages/welcome_page.dart';
import 'package:piensa_play/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:piensa_play/features/home/presentation/pages/home_page.dart';
import 'package:piensa_play/features/achievements/presentation/pages/achievements_page.dart';
import 'package:piensa_play/features/missions/presentation/pages/missions_page.dart';
import 'package:piensa_play/features/missions/presentation/pages/mission_map_page.dart';
import 'package:piensa_play/features/glossary/presentation/pages/glossary_page.dart';
import 'package:piensa_play/features/settings/presentation/pages/settings_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String tutorial = '/tutorial';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String achievements = '/achievements';
  static const String missions = '/missions';
  static const String missionMap = '/mission-map';
  static const String glossary = '/glossary';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashPage(),
      welcome: (context) => const WelcomePage(),
      onboarding: (context) => const OnboardingPage(),
      home: (context) => const HomePage(),
      achievements: (context) => const AchievementsPage(),
      missions: (context) => const MissionsPage(),
      glossary: (context) => const GlossaryPage(),
      settings: (context) => const SettingsPage(),
    };
  }
}
