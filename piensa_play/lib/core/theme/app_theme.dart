import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF4A5F7F);
  static const Color secondaryDark = Color(0xFF2C3E5F);
  static const Color tertiaryDark = Color(0xFF1A2645);
  static const Color accentYellow = Color(0xFFFDD835);
  static const Color accentGreen = Color(0xFF7FA891);
  static const Color mascotBackground = Color(0xFFCFE89C);

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
