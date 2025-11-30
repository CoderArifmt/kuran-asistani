import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../services/alarm_service.dart';
import '../providers/app_providers.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  // Only the fields that are actually used in the UI are kept.
  bool _prayerNotifications = true;
  bool _prayerBarEnabled = false;

  static const _prefsKeyPrayerNotifications = 'prayer_notifications_enabled';
  static const _prefsKeyPrayerBar = 'prayer_bar_enabled';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prayerNotifications =
          prefs.getBool(_prefsKeyPrayerNotifications) ?? true;
      _prayerBarEnabled = prefs.getBool(_prefsKeyPrayerBar) ?? false;
    });
  }

  Future<void> _togglePrayerNotifications(bool value) async {
    setState(() => _prayerNotifications = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyPrayerNotifications, value);
    if (value) {
      await NotificationService.instance.requestPermission();
      // Schedule today's adhans directly using AlarmService
      final asyncTimes = ref.read(todayPrayerTimesProvider);
      asyncTimes.whenData((times) async {
        await AlarmService.instance.scheduleTodayAdhansIfNeeded(times);
      });
    } else {
      // Cancel all notifications
      for (int i = 1; i <= 320; i++) {
        await NotificationService.instance.cancelReminder(i);
      }
      // Also hide the prayer bar if notification is off
      await NotificationService.instance.hidePrayerBar();
    }
  }

  Future<void> _togglePrayerBar(bool value) async {
    setState(() => _prayerBarEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyPrayerBar, value);
    final asyncTimes = ref.read(todayPrayerTimesProvider);
    asyncTimes.whenData((times) async {
      if (value) {
        final l10n = AppLocalizations.of(context);
        final title = l10n.todaysPrayerTimes;
        final body =
            '${l10n.fajr} ${times.fajr}  |  ${l10n.dhuhr} ${times.dhuhr}  |  ${l10n.maghrib} ${times.maghrib}';
        final bigText =
            '${l10n.fajr} ${times.fajr}  |  ${l10n.sunrise} ${times.sunrise}  |  ${l10n.dhuhr} ${times.dhuhr}\n'
            '${l10n.asr} ${times.asr}  |  ${l10n.maghrib} ${times.maghrib}  |  ${l10n.isha} ${times.isha}';
        final summaryText =
            '${l10n.sunrise} ${times.sunrise}  |  ${l10n.asr} ${times.asr}';

        await NotificationService.instance.ensurePrayerBarForToday(
          times: times,
          title: title,
          body: body,
          bigText: bigText,
          summaryText: summaryText,
        );
      } else {
        await NotificationService.instance.hidePrayerBar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).notificationSettings),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: Text(AppLocalizations.of(context).prayerTimesNotification),
            value: _prayerNotifications,
            onChanged: _togglePrayerNotifications,
          ),
          SwitchListTile.adaptive(
            title: Text(AppLocalizations.of(context).prayerBarInNotification),
            value: _prayerBarEnabled,
            onChanged: _togglePrayerBar,
          ),
        ],
      ),
    );
  }
}
