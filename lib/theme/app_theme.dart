import 'package:flutter/material.dart';

/// Available app themes.
enum AppTheme {
  light('Light'),
  dark('Dark'),
  ocean('Ocean'),
  midnight('Midnight'),
  kids('Kids'),
  disney('Disney'),
  spiderman('Spiderman'),
  superman('Superman'),
  princess('Princess');

  final String label;
  const AppTheme(this.label);
}

/// Builds a [ThemeData] for a given [AppTheme].
ThemeData buildTheme(AppTheme theme) {
  switch (theme) {
    case AppTheme.light:
      return _base(
        brightness: Brightness.light,
        primary: const Color(0xFF1E88E5),
        surface: Colors.white,
        onSurface: const Color(0xFF1A1A1A),
      );
    case AppTheme.dark:
      return _base(
        brightness: Brightness.dark,
        primary: const Color(0xFF00BCD4),
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
      );
    case AppTheme.ocean:
      return _base(
        brightness: Brightness.light,
        primary: const Color(0xFF00897B),
        surface: const Color(0xFFE0F2F1),
        onSurface: const Color(0xFF004D40),
      );
    case AppTheme.midnight:
      return _base(
        brightness: Brightness.dark,
        primary: const Color(0xFF7C4DFF),
        surface: const Color(0xFF1A1A2E),
        onSurface: const Color(0xFFE0E0FF),
      );
    case AppTheme.kids:
      return _kidsTheme();
    case AppTheme.disney:
      return _base(
        brightness: Brightness.light,
        primary: const Color(0xFF1565C0),
        surface: const Color(0xFFE3F2FD),
        onSurface: const Color(0xFF0D47A1),
      );
    case AppTheme.spiderman:
      return _base(
        brightness: Brightness.light,
        primary: const Color(0xFFD32F2F),
        surface: const Color(0xFFFFEBEE),
        onSurface: const Color(0xFFB71C1C),
      );
    case AppTheme.superman:
      return _base(
        brightness: Brightness.light,
        primary: const Color(0xFF1565C0),
        surface: const Color(0xFFFFF3E0),
        onSurface: const Color(0xFFE65100),
      );
    case AppTheme.princess:
      return _base(
        brightness: Brightness.light,
        primary: const Color(0xFFAD1457),
        surface: const Color(0xFFFCE4EC),
        onSurface: const Color(0xFF880E4F),
      );
  }
}

/// Bright, playful kids theme with cartoon-friendly colors.
ThemeData _kidsTheme() {
  const primary = Color(0xFFFF6F00); // warm orange
  const surface = Color(0xFFFFF8E1); // soft cream
  final scheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    surface: surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFB300),
      foregroundColor: Color(0xFF4E342E),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFFF6F00),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

ThemeData _base({
  required Brightness brightness,
  required Color primary,
  required Color surface,
  required Color onSurface,
}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: brightness,
    surface: surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: onSurface,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHighest,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}