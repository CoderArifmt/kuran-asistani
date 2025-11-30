import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart'; // For TimeOfDay
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

import 'package:permission_handler/permission_handler.dart'; // Add this import
import '../models/prayer_times.dart';

class NotificationService {
  NotificationService._internal();
  @visibleForTesting
  NotificationService.visibleForTesting();
  static final NotificationService instance = NotificationService._internal();
  static const int _prayerBarId = 9999; // Tek sabit

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Timezone ayarı
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      // iOS ve macOS için boş InitializationSettings ayarları
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
        debugPrint('Bildirime Tıklama: ${response.payload}');
      },
    );

    await _requestPermissions(); // ÖNEMLİ: Android 13+ ve iOS için
  }

  Future<void> requestPermission() async {
    await _requestPermissions();
  }

  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS || Platform.isMacOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// HEMEN test için bildirim (butona basınca görmen için)
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Bildirimleri',
      channelDescription: 'Test için basit bildirim kanalı',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('azan'), // ezan.mp3
      ticker: 'Test Bildirimi',
      audioAttributesUsage:
          AudioAttributesUsage.alarm, // Alarm olarak çalmasını sağlar
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      999, // rastgele id
      'Test Bildirimi',
      'Bu bir test bildirimidir.',
      platformDetails,
      payload: 'test',
    );
    debugPrint('[NotificationService] Test bildirimi gönderildi.');
  }

  /// Belirli bir tarih-saatte ezan bildirimi + ses
  Future<void> schedulePrayerNotification({
    required int id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    // Geçmişse boşuna planlama
    if (time.isBefore(DateTime.now())) {
      debugPrint(
        '[NotificationService] Geçmiş zamana ait bildirim ($id) atlandı: $time',
      );
      return;
    }

    final tz.TZDateTime tzTime = tz.TZDateTime.from(time, tz.local);
    debugPrint('[NotificationService] Raw time: $time');
    debugPrint('[NotificationService] Converted tzTime: $tzTime');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'ezan_channel_v2', // Channel ID updated
          'Ezan Bildirimleri',
          channelDescription: 'Ezan vakti geldiğinde çalan bildirimler',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('azan'), // ezan.mp3
          ticker: 'Ezan vakti',
          audioAttributesUsage:
              AudioAttributesUsage.alarm, // Alarm olarak çalmasını sağlar
        );
    // iOS için de aynı sesi kullanmak istiyorsak, iOSNotificationDetails içinde `sound` belirtmeliyiz
    // Ancak RawResourceAndroidNotificationSound doğrudan iOS'ta çalışmaz.
    // iOS için özel sesler projenin Runner/Resources klasörüne eklenmeli ve isimsiz olarak referans verilmeli.
    // Şimdilik sadece Android kısmına odaklanıyoruz.

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        // For iOS, you typically put the sound file in the Runner/Resources folder
        // and refer to it by its filename. e.g., 'azan.aiff'
        // This example focuses on Android specific sound.
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound:
            'azan.aiff', // Assuming you have azan.aiff in iOS Runner/Resources
      ),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'ezan',
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
    debugPrint('[NotificationService] Ezan bildirimi ($id) planlandı: $tzTime');
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
    debugPrint('[NotificationService] Bildirim ($id) iptal edildi.');
  }

  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
    debugPrint('[NotificationService] Tüm bildirimler iptal edildi.');
  }

  // Not: Bu metotlar NotificationService.instance.init() içinde çağrıldığı için
  // manuel olarak başka yerden çağırmaya gerek kalmayabilir.
  // Ancak yine de genel izin kontrolü için kullanılabilir.
  Future<bool?> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return androidImpl?.areNotificationsEnabled();
    }
    // iOS/macOS için izin kontrolü
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<void> ensurePrayerBarForToday({
    required PrayerTimes times,
    required String title,
    required String body,
    required String bigText,
    required String summaryText,
  }) async {
    try {
      // Tek sabit kullanılıyor
      // Günün namaz vakitlerini bir satırda birleştiriyoruz
      final String timesText =
          'İmsak: ${times.fajr} | Güneş: ${times.sunrise} | Öğle: ${times.dhuhr} | İkindi: ${times.asr} | Akşam: ${times.maghrib} | Yatsı: ${times.isha}';
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'prayer_bar_channel',
            'Namaz Çubuğu',
            channelDescription: 'Günlük namaz hatırlatma çubuğu',
            importance: Importance.low,
            priority: Priority.low,
            ongoing: true,
            autoCancel: false,
            styleInformation: BigTextStyleInformation(
              timesText,
              contentTitle: title,
              summaryText: summaryText,
            ),
          );
      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );
      await _plugin.show(
        _prayerBarId,
        title,
        body,
        platformDetails,
        payload: 'prayer_bar',
      );
      debugPrint('[NotificationService] Prayer bar shown with today\'s times');
    } catch (e) {
      debugPrint('[NotificationService] Error showing prayer bar: $e');
    }
  }

  Future<void> hidePrayerBar() async {
    await _plugin.cancel(_prayerBarId);
    debugPrint('[NotificationService] Prayer bar hidden');
  }

  /// Günün namaz vakitlerini gösteren bir çubuk bildirimi.
  Future<void> showTodayPrayerBar({required PrayerTimes times}) async {
    // Başlık ve özet aynı olabilir, body boş bırakılabilir.
    const String title = 'Namaz Çubuğu';
    const String body = '';
    const String bigText = '';
    const String summaryText = '';
    await ensurePrayerBarForToday(
      times: times,
      title: title,
      body: body,
      bigText: bigText,
      summaryText: summaryText,
    );
  }

  Future<void> showAdhanNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'ezan_channel_v2',
      'Ezan Bildirimleri',
      channelDescription: 'Ezan vakti geldiğinde çalan bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('azan'),
      ticker: 'Ezan vakti',
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, platformDetails, payload: 'ezan');
  }

  Future<void> scheduleTestNotification({
    required String prayerName,
    required Duration delay,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = now.add(delay);

    final int id = now.millisecondsSinceEpoch ~/ 1000;

    debugPrint(
      '[NotificationService] Test scheduling: Now=$now, Scheduled=$scheduledDate',
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'ezan_channel_v2',
          'Ezan Bildirimleri',
          channelDescription: 'Ezan vakti geldiğinde çalan bildirimler',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('azan'),
          ticker: 'Ezan vakti',
          audioAttributesUsage: AudioAttributesUsage.alarm,
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.zonedSchedule(
      id,
      'Namaz Vakti',
      '$prayerName vakti geldi.',
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'ezan_test',
    );
  }

  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_reminders',
          'Günlük Hatırlatmalar',
          channelDescription: 'Günlük Kur\'an ve dua hatırlatmaları',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  /// Günün namaz çubuğu hatırlatıcı (06:00) planlar.
  Future<void> scheduleDailyPrayerReminder() async {
    const int id = 1000;
    const String title = 'Namaz Çubuğu Hatırlatıcı';
    const String body = 'Namaz vakti geldi!';
    final TimeOfDay time = const TimeOfDay(hour: 6, minute: 0);
    await scheduleDailyReminder(id: id, title: title, body: body, time: time);
    debugPrint(
      '[NotificationService] Daily prayer reminder scheduled at 06:00',
    );
  }

  Future<String> getPendingNotificationCount() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _plugin.pendingNotificationRequests();

    if (pendingNotificationRequests.isEmpty) {
      return 'Bekleyen bildirim yok.';
    }

    final buffer = StringBuffer();
    buffer.writeln('Toplam: ${pendingNotificationRequests.length} bildirim\n');

    // Sort by ID to make it easier to read
    pendingNotificationRequests.sort((a, b) => a.id.compareTo(b.id));

    for (final notification in pendingNotificationRequests) {
      buffer.writeln('ID: ${notification.id}');
      buffer.writeln('Başlık: ${notification.title}');
      buffer.writeln('İçerik: ${notification.body}');
      buffer.writeln('Payload: ${notification.payload}');
      buffer.writeln('---');
    }

    return buffer.toString();
  }
}
