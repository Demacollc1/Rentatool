import 'package:flutter/material.dart';

/// Identidad DEMACO: industrial, amarillo/negro (mundo herramienta).
class AppTheme {
  static const yellow = Color(0xFFFFC400);
  static const ink = Color(0xFF15130D);
  static const steel = Color(0xFF3A3D42);
  static const paper = Color(0xFFF7F6F2);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: yellow,
          brightness: Brightness.light,
          primary: const Color(0xFF8A6D00),
          secondary: steel,
        ),
        scaffoldBackgroundColor: paper,
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: yellow,
        ),
      );
}
