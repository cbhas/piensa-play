import 'package:flutter/material.dart';

/// Sistema visual unico de PiensaPlay, alineado con el manual de marca.
class AppTheme {
  static const Color primaryDark = Color(0xFF132757);
  static const Color secondaryDark = Color(0xFF243B72);
  static const Color tertiaryDark = Color(0xFF081A3D);

  static const Color accentGreen = Color(0xFFBDD87B);
  static const Color accentBlue = Color(0xFF75C9E8);
  static const Color accentYellow = Color(0xFFF6E16B);
  static const Color accentPink = Color(0xFFE86F9B);
  static const Color accentRed = Color(0xFFE85D5D);
  static const Color accentYellowAlt = Color(0xFFFFD447);
  static const Color accentGreenSage = Color(0xFF78A88A);

  static const Color backgroundLight = Color(0xFFF7F8F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF18223A);
  static const Color muted = Color(0xFF667085);
  static const Color mascotBackground = Color(0xFFDDEAB8);

  static const Color backgroundDark = Color(0xFF08132C);
  static const Color surfaceDark = Color(0xFF122143);
  static const Color cardDark = Color(0xFF1B2D57);
  static const Color textPrimaryDark = Color(0xFFF8FAFF);
  static const Color textSecondaryDark = Color(0xFFC7D1E8);

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryDark,
      brightness: Brightness.light,
      primary: primaryDark,
      secondary: accentGreen,
      surface: surfaceLight,
    );
    return _theme(scheme, false);
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: accentGreen,
      brightness: Brightness.dark,
      primary: accentGreen,
      secondary: accentYellow,
      surface: surfaceDark,
    );
    return _theme(scheme, true);
  }

  static ThemeData _theme(ColorScheme scheme, bool dark) {
    final foreground = dark ? textPrimaryDark : ink;
    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? backgroundDark : backgroundLight,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: dark ? cardDark : surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: dark ? Colors.white12 : const Color(0xFFE5E9F0),
          ),
        ),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(color: foreground, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: foreground, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: foreground, height: 1.45),
        bodyMedium: TextStyle(
          color: dark ? textSecondaryDark : muted,
          height: 1.45,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 56),
          backgroundColor: dark ? accentGreen : primaryDark,
          foregroundColor: dark ? tertiaryDark : Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 56),
          foregroundColor: dark ? accentGreen : primaryDark,
          side: BorderSide(color: dark ? accentGreen : primaryDark, width: 1.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? cardDark : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dark ? surfaceDark : Colors.white,
        indicatorColor: accentGreen.withValues(alpha: 0.45),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(color: foreground, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static BoxDecoration get gradientBackground => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryDark, secondaryDark, tertiaryDark],
    ),
  );

  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: primaryDark.withValues(alpha: 0.16),
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
  ];
}
