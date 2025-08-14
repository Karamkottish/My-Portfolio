import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF0EA5E9),
  brightness: Brightness.light,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF0EA5E9),
  brightness: Brightness.dark,
);

ThemeData appTheme(Brightness b) {
  final cs = b == Brightness.dark ? darkColorScheme : lightColorScheme;
  return ThemeData(
    colorScheme: cs,
    useMaterial3: true,
    scaffoldBackgroundColor: cs.surface,
    textTheme: const TextTheme(
      displayLarge:
      TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1.0),
      titleLarge: TextStyle(fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(height: 1.5),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: cs.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
