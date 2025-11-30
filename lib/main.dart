import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'theme/app_theme.dart';
import 'theme/theme_mode_controller.dart';
import 'pages/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/cache_service.dart';
import 'services/alarm_service.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/font_size_provider.dart';

final AudioPlayer player = AudioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

  await Future.wait([
    AlarmService.instance.initialize(),
    NotificationService.instance.initialize(),
    CacheService.instance.initialize(),
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final animationsEnabled = ref.watch(animationsEnabledProvider);
    final fontSizeScale = ref.watch(fontSizeProvider);

    return MaterialApp(
      key: ValueKey(locale.languageCode),
      title: 'Prayer & Quran Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        animationsEnabled: animationsEnabled,
        fontSizeScale: fontSizeScale,
      ),
      darkTheme: AppTheme.dark(
        animationsEnabled: animationsEnabled,
        fontSizeScale: fontSizeScale,
      ),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const StitchSplashScreen(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: Builder(
          builder: (context) {
            return ResponsiveScaledBox(
              width: ResponsiveValue<double>(
                context,
                defaultValue: 480,
                conditionalValues: [
                  Condition.equals(name: MOBILE, value: 480),
                  Condition.between(start: 481, end: 800, value: 800),
                  Condition.between(start: 801, end: 1920, value: 1920),
                  Condition.largerThan(name: DESKTOP, value: 1920),
                ],
              ).value,
              child: ClampingScrollWrapper.builder(context, child!),
            );
          },
        ),
        breakpoints: [
          const Breakpoint(start: 0, end: 480, name: MOBILE),
          const Breakpoint(start: 481, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
