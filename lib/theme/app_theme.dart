import 'package:flutter/material.dart';

/// Available app themes.
enum AppTheme {
  light('Light'),
  dark('Dark'),
  ocean('Ocean'),
  midnight('Midnight');

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
  }
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