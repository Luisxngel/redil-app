import 'package:flutter/material.dart';
import 'theme_cubit.dart';

class AppTheme {
  static ThemeData getTheme(AppThemeCandidate theme) {
    switch (theme) {
      case AppThemeCandidate.blue:
        return _baseTheme(
          primary: const Color(0xFF1565C0), // Comandante Blue (Colors.blue[800])
          secondary: const Color(0xFF448AFF),
          background: const Color(0xFFE3F2FD),
        );
      case AppThemeCandidate.teal:
        return _baseTheme(
          primary: const Color(0xFF00897B),
          secondary: const Color(0xFF69F0AE),
          background: const Color(0xFFF1F8E9),
        );
      case AppThemeCandidate.purple:
        return _baseTheme(
          primary: const Color(0xFF6A1B9A),
          secondary: const Color(0xFFEA80FC),
          background: const Color(0xFFF3E5F5),
        );
      case AppThemeCandidate.orange:
        return _baseTheme(
          primary: Colors.deepOrange, // Rescue Orange
          secondary: Colors.orangeAccent,
          background: const Color(0xFFFFF3E0), // Orange[50]
        );
      case AppThemeCandidate.dark:
        return ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212), // Tactical Dark Background
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, // Primary Accent set to Blue (True Blue)
            primary: const Color(0xFF2196F3), // Explicit vibrant Blue
            brightness: Brightness.dark,
            surface: const Color(0xFF1E1E1E), // Surface
          ),
          cardColor: const Color(0xFF1E1E1E),
          dialogBackgroundColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          inputDecorationTheme: _inputDecorationTheme(isDark: true),
        );
    }
  }

  static ThemeData _baseTheme({
    required Color primary,
    required Color secondary,
    required Color background,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.black87,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(isDark: false, primary: primary),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({bool isDark = false, Color? primary}) {
    final borderColor = isDark ? Colors.white54 : Colors.grey;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary ?? Colors.teal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
