import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF14B866);
  static const Color _bgLight = Color(0xFFF6F8F7);
  // Koyu tema için biraz daha derin, nötr bir arka plan paleti
  static const Color _bgDark = Color(0xFF020617); // ana arka plan
  static const Color _surfaceDark = Color(0xFF0B1120); // kartlar / yüzeyler
  static const Color _surfaceDarkHigh = Color(0xFF111827); // vurgulu kartlar

  static ThemeData light({
    bool animationsEnabled = true,
    double fontSizeScale = 1.0,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      primary: _primary,
      surface: Colors.white,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bgLight,
      textTheme: _safeTextTheme(Typography.material2021().black),
      pageTransitionsTheme: animationsEnabled
          ? null
          : const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
                TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
                TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
              },
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: _bgLight.withValues(alpha: 0.8),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _bgLight.withValues(alpha: 0.8),
        selectedItemColor: _primary,
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
      ),
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontSizeFactor: fontSizeScale),
    );
  }

  static ThemeData dark({
    bool animationsEnabled = true,
    double fontSizeScale = 1.0,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      surface: _surfaceDark,
      onSurface: const Color(0xFFE5E7EB),
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bgDark,
      canvasColor: _bgDark,
      textTheme: _safeTextTheme(Typography.material2021().white),
      pageTransitionsTheme: animationsEnabled
          ? null
          : const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
                TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
                TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
              },
            ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDarkHigh,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: _surfaceDarkHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      dividerColor: Colors.white.withValues(alpha: 0.06),
      iconTheme: const IconThemeData(color: Color(0xFFE5E7EB)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _bgDark.withValues(alpha: 0.9),
        selectedItemColor: _primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
      ),
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        bodyColor: const Color(0xFFE5E7EB),
        displayColor: const Color(0xFFE5E7EB),
        fontSizeFactor: fontSizeScale,
      ),
    );
  }

  static TextTheme _safeTextTheme(TextTheme original) {
    // Explicitly ensure all M3 styles have a font size to prevent assertions during scaling
    return original
        .copyWith(
          displayLarge:
              original.displayLarge?.copyWith(fontSize: 57) ??
              const TextStyle(fontSize: 57),
          displayMedium:
              original.displayMedium?.copyWith(fontSize: 45) ??
              const TextStyle(fontSize: 45),
          displaySmall:
              original.displaySmall?.copyWith(fontSize: 36) ??
              const TextStyle(fontSize: 36),
          headlineLarge:
              original.headlineLarge?.copyWith(fontSize: 32) ??
              const TextStyle(fontSize: 32),
          headlineMedium:
              original.headlineMedium?.copyWith(fontSize: 28) ??
              const TextStyle(fontSize: 28),
          headlineSmall:
              original.headlineSmall?.copyWith(fontSize: 24) ??
              const TextStyle(fontSize: 24),
          titleLarge:
              original.titleLarge?.copyWith(fontSize: 22) ??
              const TextStyle(fontSize: 22),
          titleMedium:
              original.titleMedium?.copyWith(fontSize: 16) ??
              const TextStyle(fontSize: 16),
          titleSmall:
              original.titleSmall?.copyWith(fontSize: 14) ??
              const TextStyle(fontSize: 14),
          bodyLarge:
              original.bodyLarge?.copyWith(fontSize: 16) ??
              const TextStyle(fontSize: 16),
          bodyMedium:
              original.bodyMedium?.copyWith(fontSize: 14) ??
              const TextStyle(fontSize: 14),
          bodySmall:
              original.bodySmall?.copyWith(fontSize: 12) ??
              const TextStyle(fontSize: 12),
          labelLarge:
              original.labelLarge?.copyWith(fontSize: 14) ??
              const TextStyle(fontSize: 14),
          labelMedium:
              original.labelMedium?.copyWith(fontSize: 12) ??
              const TextStyle(fontSize: 12),
          labelSmall:
              original.labelSmall?.copyWith(fontSize: 11) ??
              const TextStyle(fontSize: 11),
        )
        .apply(fontFamily: 'Inter');
  }
}

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
