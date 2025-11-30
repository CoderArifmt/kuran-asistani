import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale provider for managing app language
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('tr', 'TR')) {
    _loadLocale();
  }

  static const String _localeKey = 'app_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null) {
      if (languageCode == 'en') {
        state = const Locale('en', 'US');
      } else {
        state = const Locale('tr', 'TR');
      }
    } else {
      // First run: Check system locale
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (systemLocale.languageCode == 'tr') {
        state = const Locale('tr', 'TR');
        await prefs.setString(_localeKey, 'tr');
      } else {
        state = const Locale('en', 'US');
        await prefs.setString(_localeKey, 'en');
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    if (state.languageCode == 'tr') {
      await setLocale(const Locale('en', 'US'));
    } else {
      await setLocale(const Locale('tr', 'TR'));
    }
  }
}
