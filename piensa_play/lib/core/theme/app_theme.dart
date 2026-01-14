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
  static const Color accentRed = Color(0xFFFF6B6B); // Red for Ciberseguridad

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

  // ========== Dark Mode Colors ==========
  static const Color backgroundDark = Color(0xFF1A1A1A); // Dark background
  static const Color surfaceDark = Color(0xFF2D2D2D); // Dark surface
  static const Color cardDark = Color(0xFF3A3A3A); // Dark cards
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White text
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Gray text

  // ========== Light Theme ==========
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Roboto',

      colorScheme: const ColorScheme.light(
        primary: primaryDark,
        secondary: accentYellow,
        surface: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: tertiaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: primaryDark),
        bodyMedium: TextStyle(color: primaryDark),
        titleLarge: TextStyle(color: primaryDark, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ========== Dark Theme ==========
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentGreen,
      scaffoldBackgroundColor: backgroundDark,
      fontFamily: 'Roboto',

      colorScheme: const ColorScheme.dark(
        primary: accentGreen,
        secondary: accentYellow,
        surface: surfaceDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimaryDark),
        bodyMedium: TextStyle(color: textSecondaryDark),
        titleLarge: TextStyle(
          color: textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
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
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
}
