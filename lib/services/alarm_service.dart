import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/prayer_times.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void playAdhan() {
  final player = AudioPlayer();
  player.setAsset('assets/audio/azan.mp3');
  player.play();
}

class AlarmService {
  static final AlarmService instance = AlarmService._internal();
  AlarmService._internal();

  Future<void> initialize() async {
    await AndroidAlarmManager.initialize();
  }

  Future<void> scheduleAdhan(DateTime prayerTime, int prayerId) async {
    await AndroidAlarmManager.oneShotAt(
      prayerTime,
      prayerId,
      playAdhan,
      exact: true,
      wakeup: true,
    );
  }

  /// Bugün için (cihaz tarihine göre) ezanları planlar; aynı gün ikinci kez çağrılırsa atlar.
  Future<void> scheduleTodayAdhansIfNeeded(PrayerTimes times) async {
    final prefs = await SharedPreferences.getInstance();

    // Son planlama tarihini kontrol et - aynı gün tekrar planlama yapma
    final lastScheduledStr = prefs.getString('last_adhan_scheduled_date');
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    if (lastScheduledStr == today) {
      debugPrint('[AdhanSchedule] Bugün için zaten planlandı, atlaniyor.');
      return;
    }

    await _scheduleForToday(times, prefs, today);
  }

  /// Ayarlarda değişiklik olduğunda, bugünkü ezanları iptal edip yeniden planlar.
  Future<void> rescheduleTodayAdhans(PrayerTimes times) async {
    final prefs = await SharedPreferences.getInstance();

    // Mevcut ezan alarmlarını iptal et (1-5 ID'leri kullanıyoruz)
    for (int i = 1; i <= 5; i++) {
      await AndroidAlarmManager.cancel(i);
    }

    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    await _scheduleForToday(times, prefs, today);
  }

  Future<void> _scheduleForToday(
    PrayerTimes times,
    SharedPreferences prefs,
    String today,
  ) async {
    final master = prefs.getBool('adhan_master') ?? true;
    final prayerNotifications =
        prefs.getBool('prayer_notifications_enabled') ?? true;
    debugPrint(
      '[AdhanSchedule] master=$master, prayer_notifications=$prayerNotifications',
    );
    if (!master || !prayerNotifications) {
      debugPrint(
        '[AdhanSchedule] Planlama yapılmadı, çünkü master/prayer_notifications kapalı.',
      );
      return;
    }

    final fajrOn = prefs.getBool('adhan_fajr') ?? true;
    final dhuhrOn = prefs.getBool('adhan_dhuhr') ?? true;
    final asrOn = prefs.getBool('adhan_asr') ?? true;
    final maghribOn = prefs.getBool('adhan_maghrib') ?? true;
    final ishaOn = prefs.getBool('adhan_isha') ?? true;

    DateTime? nextOccurrence(String hm) {
      final now = DateTime.now();
      final match = RegExp(r'(\d{1,2}):(\d{1,2})').firstMatch(hm);
      if (match != null) {
        final h = int.tryParse(match.group(1)!) ?? 0;
        final m = int.tryParse(match.group(2)!) ?? 0;
        var candidate = DateTime(now.year, now.month, now.day, h, m);
        if (candidate.isBefore(now)) {
          candidate = candidate.add(const Duration(days: 1));
        }
        return candidate;
      }
      return null;
    }

    final prayerIdMap = {
      'Fajr': 1,
      'Dhuhr': 2,
      'Asr': 3,
      'Maghrib': 4,
      'Isha': 5,
    };

    final prayersToSchedule = {
      if (fajrOn) 'Fajr': times.fajr,
      if (dhuhrOn) 'Dhuhr': times.dhuhr,
      if (asrOn) 'Asr': times.asr,
      if (maghribOn) 'Maghrib': times.maghrib,
      if (ishaOn) 'Isha': times.isha,
    };

    // Dil bilgisini al (varsayılan Türkçe)
    final languageCode = prefs.getString('app_locale') ?? 'tr';

    String localizedPrayerName(String prayerKey) {
      if (languageCode == 'en') {
        switch (prayerKey) {
          case 'Fajr':
            return 'Fajr';
          case 'Dhuhr':
            return 'Dhuhr';
          case 'Asr':
            return 'Asr';
          case 'Maghrib':
            return 'Maghrib';
          case 'Isha':
            return 'Isha';
          default:
            return prayerKey;
        }
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

    for (final entry in prayersToSchedule.entries) {
      final prayerName = entry.key;
      final prayerTimeStr = entry.value;
      final prayerId = prayerIdMap[prayerName];
      final occurrence = nextOccurrence(prayerTimeStr);

      if (prayerId != null && occurrence != null) {
        // Ezan sesini çalmak için alarm kur
        await scheduleAdhan(occurrence, prayerId);

        // Aynı anda bildirim planla
        final localName = localizedPrayerName(prayerName);
        final title = languageCode == 'en'
            ? '$localName prayer time'
            : '$localName vakti girdi';
        final body = languageCode == 'en'
            ? 'It is now time for $localName prayer.'
            : '$localName namaz vakti geldi.';

        await NotificationService.instance.schedulePrayerNotification(
          id: 100 + prayerId, // ezan alarmlarından ayrı ID aralığı kullan
          time: occurrence,
          title: title,
          body: body,
        );
      }
    }

    await prefs.setString('last_adhan_scheduled_date', today);
    debugPrint(
      '[AdhanSchedule] Tüm ezanlar başarıyla planlandı, tarih kaydedildi: $today',
    );
  }
}
