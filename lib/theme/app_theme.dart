import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF14B866);
  static const Color _bgLight = Color(0xFFF6F8F7);
  // Koyu tema için biraz daha derin, nötr bir arka plan paleti
  static const Color _bgDark = Color(0xFF020617); // ana arka plan
  static const Color _surfaceDark = Color(0xFF0B1120); // kartlar / yüzeyler
  static const Color _surfaceDarkHigh = Color(0xFF111827); // vurgulu kartlar

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      primary: _primary,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bgLight,
      fontFamily: 'Inter',
      appBarTheme: AppBarTheme(
        backgroundColor: _bgLight.withValues(alpha: 0.8),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _bgLight.withValues(alpha: 0.8),
        selectedItemColor: _primary,
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      surface: _surfaceDark,
      onSurface: const Color(0xFFE5E7EB),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bgDark,
      canvasColor: _bgDark,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDarkHigh,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: _surfaceDarkHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      dividerColor: Colors.white.withValues(alpha: 0.06),
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: const Color(0xFFE5E7EB),
            displayColor: const Color(0xFFE5E7EB),
          ),
      iconTheme: const IconThemeData(color: Color(0xFFE5E7EB)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _bgDark.withValues(alpha: 0.9),
        selectedItemColor: _primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
