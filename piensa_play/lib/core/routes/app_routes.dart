import 'package:flutter/material.dart';
import 'package:piensa_play/features/splash/presentation/pages/splash_page.dart';
import 'package:piensa_play/features/welcome/presentation/pages/welcome_page.dart';
import 'package:piensa_play/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:piensa_play/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String tutorial = '/tutorial';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashPage(),
      welcome: (context) => const WelcomePage(),
      onboarding: (context) => const OnboardingPage(),
      home: (context) => const HomePage(), // Nueva ruta agregada
    };
  }
}
