import 'package:flutter/material.dart';

class AppTheme {
  // ========== Primary Colors (Navy Blues) ==========
  static const Color primaryDark = Color(0xFF4A5F7F); // Navy blue (main)
  static const Color secondaryDark = Color(0xFF2C3E5F); // Darker navy
  static const Color tertiaryDark = Color(0xFF1A2645); // Darkest navy

  // ========== Accent Colors (Feature Cards) ==========
  static const Color accentGreen = Color(
    0xFFA4D65E,
  ); // Bright green (Juegos, Achievements)
  static const Color accentBlue = Color(
    0xFF6EC6FF,
  ); // Light blue (Glosario, Progress)
  static const Color accentYellow = Color(0xFFF4D03F); // Bright yellow (Logros)
  static const Color accentPink = Color(0xFFE91E63); // Pink/Magenta (Misiones)

  // ========== Secondary Accent Colors ==========
  static const Color accentYellowAlt = Color(
    0xFFFDD835,
  ); // Alternative yellow (icons)
  static const Color accentGreenSage = Color(
    0xFF7FA891,
  ); // Sage green (alternative)

  // ========== Background Colors ==========
  static const Color backgroundLight = Color(
    0xFFF5F5F5,
  ); // Light gray background
  static const Color mascotBackground = Color(
    0xFFCFE89C,
  ); // Light green (mascot)

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryDark,
        secondary: accentYellow,
      ),
    );
  }

  static BoxDecoration get gradientBackground {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryDark, secondaryDark, tertiaryDark],
      ),
    );
  }

  static List<BoxShadow> get defaultShadow {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
}
