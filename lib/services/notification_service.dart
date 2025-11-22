import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../models/prayer_times.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  static const int _prayerBarNotificationId = 9001;
  static const String _prayerBarPrefsKey = 'prayer_bar_enabled';
  static const String _muteAdhanActionId = 'ACTION_MUTE_ADHAN';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.actionId == _muteAdhanActionId) {
          await _handleMuteAdhanAction();
        }
      },
    );
  }

  Future<void> _handleMuteAdhanAction() async {
    final prefs = await SharedPreferences.getInstance();
    // Ezan master anahtarını kapat
    await prefs.setBool('adhan_master', false);
    await prefs.setBool('prayer_notifications_enabled', false);

    // Gelecekteki tüm ezan alarmlarını iptal et (1-5 ID'lerini kullanıyoruz)
    for (int i = 1; i <= 5; i++) {
      await AndroidAlarmManager.cancel(i);
    }
    // Planlanmış namaz bildirimlerini iptal et (100-105 aralığı)
    for (int i = 101; i <= 105; i++) {
      await _plugin.cancel(i);
    }
  }

  Future<void> showPrayerBar({
    required PrayerTimes times,
    required String title,
    required String body,
    required String bigText,
    required String summaryText,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'prayer_bar_channel',
      'Prayer Times Bar',
      channelDescription:
          'Permanently shows today\'s prayer times in the notification bar.',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      showWhen: false,
      category: AndroidNotificationCategory.status,
      onlyAlertOnce: true,
      color: const Color(0xFF14B866),
      styleInformation: BigTextStyleInformation(
        bigText,
        contentTitle: title,
        summaryText: summaryText,
      ),
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(_prayerBarNotificationId, title, body, details);
  }

  Future<void> hidePrayerBar() async {
    await _plugin.cancel(_prayerBarNotificationId);
  }

  Future<void> ensurePrayerBarForToday({
    required PrayerTimes times,
    required String title,
    required String body,
    required String bigText,
    required String summaryText,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prayerBarPrefsKey) ?? false;
    if (!enabled) return;

    await requestPermission();
    await showPrayerBar(
      times: times,
      title: title,
      body: body,
      bigText: bigText,
      summaryText: summaryText,
    );
  }

  Future<void> showImmediateTestAdhan() async {
    await requestPermission();

    const androidDetails = AndroidNotificationDetails(
      'test_channel_v1',
      'Test Notifications',
      channelDescription: 'Simple test notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Test notification',
      'If you see this, local notifications work.',
      notificationDetails,
    );
  }

  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final firstTime = scheduled.isAfter(now)
        ? scheduled
        : scheduled.add(const Duration(days: 1));

    final tzTime = tz.TZDateTime.from(firstTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'daily_reminders_channel',
      'Daily reminders',
      channelDescription: 'Quran and dua reminders.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Tek seferlik namaz vakti bildirimi (cihaz kapalı olsa bile saat geldiğinde tetiklenir).
  Future<void> schedulePrayerNotification({
    required int id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    final tzTime = tz.TZDateTime.from(time, tz.local);

    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('app_locale') ?? 'tr';
    final muteLabel = languageCode == 'en' ? 'Mute' : 'Sustur';

    final androidDetails = AndroidNotificationDetails(
      'prayer_adhan_channel',
      'Prayer Adhan',
      channelDescription: 'Adhan notifications at prayer times.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          _muteAdhanActionId,
          muteLabel,
          showsUserInterface: false,
        ),
      ],
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  Future<bool?> requestPermission() async {
    if (Platform.isAndroid) {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return androidImpl?.requestNotificationsPermission();
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final iosImpl = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
    }

    return null;
  }

  Future<bool?> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return androidImpl?.areNotificationsEnabled();
    }

    return null;
  }

  Future<void> openNotificationSettings() async {}
}
