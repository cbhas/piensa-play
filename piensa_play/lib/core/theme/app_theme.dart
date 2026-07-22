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

  // Cream/ivory base — deliberately not stark white, so the app reads as
  // warm and hand-designed rather than a bare admin panel.
  static const Color backgroundLight = Color(0xFFF7F3EA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF18223A);
  static const Color muted = Color(0xFF6B7280);
  static const Color mascotBackground = Color(0xFFDDEAB8);

  static const Color backgroundDark = Color(0xFF081327);
  static const Color surfaceDark = Color(0xFF102038);
  static const Color cardDark = Color(0xFF16234A);
  static const Color textPrimaryDark = Color(0xFFF4F7FF);
  static const Color textSecondaryDark = Color(0xFFA9B6D6);

  // ---------------------------------------------------------------------
  // Restrained accent pairs — one fill + one text color per semantic
  // meaning, tuned separately for light/dark so accents stay legible
  // instead of just inverting. Prefer these over reaching for a raw
  // accent* color directly on a card: pick ONE accent per element.
  // ---------------------------------------------------------------------
  static Color greenFill(bool dark) =>
      dark ? const Color(0xFF3E5C2C) : const Color(0xFFBFDA8E);
  static Color greenText(bool dark) =>
      dark ? const Color(0xFFBFE896) : const Color(0xFF3F6B2C);

  static Color goldFill(bool dark) =>
      dark ? const Color(0xFF5A4614) : const Color(0xFFFFD447);
  static Color goldText(bool dark) =>
      dark ? const Color(0xFFFFD447) : const Color(0xFF7A5B00);

  static Color coralFill(bool dark) =>
      dark ? const Color(0xFF5C2438) : const Color(0xFFE86F9B);
  static Color coralText(bool dark) =>
      dark ? const Color(0xFFF0A6C2) : const Color(0xFF9C2E56);

  static Color blueFill(bool dark) =>
      dark ? const Color(0xFF1E3A5C) : const Color(0xFFBEE3F5);
  static Color blueText(bool dark) =>
      dark ? const Color(0xFFA9DCF2) : const Color(0xFF2A6B85);

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

  // ---------------------------------------------------------------------
  // Design tokens (additive) — used to keep spacing/rounding consistent
  // across the "playful but calm" refresh without touching brand colors.
  // ---------------------------------------------------------------------
  static const double radiusSm = 14;
  static const double radiusMd = 20;
  static const double radiusLg = 28;
  static const double radiusXl = 36;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  /// Soft, low-contrast shadow for small interactive elements (chips,
  /// avatar bubbles) — lighter than [defaultShadow] which is meant for
  /// large hero cards.
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primaryDark.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  /// A cheerful two-tone gradient for celebratory moments (streaks,
  /// rewards, correct answers) — used sparingly so it stays a highlight
  /// rather than the norm.
  static const LinearGradient sunshineGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentYellow, accentYellowAlt],
  );

  static const LinearGradient freshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGreen, accentBlue],
  );

  static const LinearGradient playfulGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPink, accentBlue],
  );

  static BoxDecoration glowCircle(Color color, {double alpha = 0.22}) =>
      BoxDecoration(
        color: color.withValues(alpha: alpha),
        shape: BoxShape.circle,
      );
}
