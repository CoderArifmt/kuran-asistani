import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/prayer_times.dart';
import 'notification_service.dart';

class AlarmService {
  static final AlarmService instance = AlarmService._internal();
  AlarmService._internal();
  @visibleForTesting
  AlarmService.visibleForTesting();

  Future<void> initialize() async {
    // Initialization logic can be added here if needed in the future.
  }

  Future<void> scheduleTodayAdhansIfNeeded(PrayerTimes times) async {
    final prefs = await SharedPreferences.getInstance();
    await _scheduleForDay(times, prefs);
  }

  /// Schedules a single prayer notification with a unique ID.
  Future<void> scheduleAdhan(
    DateTime prayerTime,
    int prayerId,
    String prayerName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('app_locale') ?? 'tr';

    final title = languageCode == 'en' ? 'Time for Prayer' : 'Namaz Vakti';
    final body = languageCode == 'en'
        ? 'It is time for $prayerName prayer.'
        : '$prayerName vakti geldi.';

    await NotificationService.instance.schedulePrayerNotification(
      id: prayerId,
      time: prayerTime,
      title: title,
      body: body,
    );

    debugPrint(
      '[AdhanSchedule] #$prayerId ($prayerName) native notification scheduled for: $prayerTime',
    );
  }

  /// Schedules all prayer times for a given list of monthly prayer data.
  /// This cancels all previously scheduled alarms and creates new ones for the upcoming month.
  Future<void> scheduleMonthlyAdhans(List<PrayerTimes> monthlyPrayers) async {
    debugPrint(
      '[AdhanSchedule] Starting monthly rescheduling of all prayer time alarms...',
    );
    final prefs = await SharedPreferences.getInstance();
    final notificationService = NotificationService.instance;

    // Cancel all notifications (much faster than looping)
    debugPrint('[AdhanSchedule] Cancelling all existing notifications...');
    await notificationService.cancelAllReminders();

    // Restore the persistent prayer bar immediately
    // We need to fetch today's times again or pass them in, but for now
    // we can rely on the UI to refresh it, or better, we just let it be recreated
    // when the user goes to home screen.
    // Actually, better to just let it be. The home screen logic ensures it's shown.

    debugPrint('[AdhanSchedule] All notifications cancelled.');

    // Check if notifications are enabled globally.
    final master = prefs.getBool('adhan_master') ?? true;
    final prayerNotifications =
        prefs.getBool('prayer_notifications_enabled') ?? true;
    if (!master || !prayerNotifications) {
      debugPrint(
        '[AdhanSchedule] Scheduling skipped because master or prayer notifications are disabled.',
      );
      return;
    }

    // Schedule new alarms for each day in the provided list.
    for (final dailyTimes in monthlyPrayers) {
      await _scheduleForDay(dailyTimes, prefs);
    }

    // Record the date of the last successful full scheduling.
    final now = DateTime.now();
    await prefs.setString('last_full_schedule_date', now.toIso8601String());
    debugPrint(
      '[AdhanSchedule] Successfully scheduled all prayer times for the month.',
    );
  }

  /// Schedules all enabled prayer times for a single day.
  Future<void> _scheduleForDay(
    PrayerTimes times,
    SharedPreferences prefs,
  ) async {
    final fajrOn = prefs.getBool('adhan_fajr') ?? true;
    final dhuhrOn = prefs.getBool('adhan_dhuhr') ?? true;
    final asrOn = prefs.getBool('adhan_asr') ?? true;
    final maghribOn = prefs.getBool('adhan_maghrib') ?? true;
    final ishaOn = prefs.getBool('adhan_isha') ?? true;

    final prayersToSchedule = {
      if (fajrOn) 'Fajr': times.fajr,
      if (dhuhrOn) 'Dhuhr': times.dhuhr,
      if (asrOn) 'Asr': times.asr,
      if (maghribOn) 'Maghrib': times.maghrib,
      if (ishaOn) 'Isha': times.isha,
    };

    final languageCode = prefs.getString('app_locale') ?? 'tr';

    String localizedPrayerName(String prayerKey) {
      if (languageCode == 'en') {
        return prayerKey; // Fajr, Dhuhr, Asr, Maghrib, Isha
      } else {
        switch (prayerKey) {
          case 'Fajr':
            return 'İmsak';
          case 'Dhuhr':
            return 'Öğle';
          case 'Asr':
            return 'İkindi';
          case 'Maghrib':
            return 'Akşam';
          case 'Isha':
            return 'Yatsı';
          default:
            return prayerKey;
        }
      }
    }

    final prayerIdMap = {
      'Fajr': 1,
      'Dhuhr': 2,
      'Asr': 3,
      'Maghrib': 4,
      'Isha': 5,
    };
    final now = DateTime.now();
    final dayDate = times.date;

    for (final entry in prayersToSchedule.entries) {
      final key = entry.key;
      final hm = entry.value; // "HH:mm"
      final baseId = prayerIdMap[key]!;

      final match = RegExp(r'(\d{1,2}):(\d{1,2})').firstMatch(hm);
      if (match != null) {
        final h = int.tryParse(match.group(1)!) ?? 0;
        final m = int.tryParse(match.group(2)!) ?? 0;
        var scheduleTime = DateTime(
          dayDate.year,
          dayDate.month,
          dayDate.day,
          h,
          m,
        );

        // Only schedule notifications for times in the future.
        if (scheduleTime.isAfter(now)) {
          // Generate a unique ID for each prayer time on each day of the month.
          final uniqueId = (dayDate.day * 10) + baseId;
          debugPrint(
            '[AdhanSchedule] Scheduling $key (Visual ID: $uniqueId) for $scheduleTime',
          );
          await scheduleAdhan(scheduleTime, uniqueId, localizedPrayerName(key));
        } else {
          debugPrint(
            '[AdhanSchedule] Skipping $key (Date: ${dayDate.day}) as it is in the past: $scheduleTime',
          );
        }
      }
    }
  }
}
