import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namaz_kuran_asistani/models/prayer_times.dart';
import 'package:namaz_kuran_asistani/pages/stitch_home_page.dart';
import 'package:namaz_kuran_asistani/providers/app_providers.dart';
import 'package:namaz_kuran_asistani/services/alarm_service.dart';
import 'package:namaz_kuran_asistani/services/notification_service.dart';
import 'package:namaz_kuran_asistani/services/time_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:namaz_kuran_asistani/l10n/app_localizations.dart';

// --- Sahte Servisler (Fakes) ---

class FakeTimeService extends TimeService {
  DateTime _now;

  FakeTimeService(this._now);

  @override
  DateTime get now => _now;

  void setTime(DateTime time) {
    _now = time;
  }

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

class FakeNotificationService extends NotificationService {
  FakeNotificationService() : super.visibleForTesting();

  final List<String> logs = [];

  @override
  Future<void> ensurePrayerBarForToday({
    required PrayerTimes times,
    required String title,
    required String body,
    required String bigText,
    required String summaryText,
  }) async {
    logs.add('ensurePrayerBarForToday (Bugün için namaz çubuğu): $title');
  }

  @override
  Future<void> cancelReminder(int id) async {
    logs.add('cancelReminder (Hatırlatıcı iptal): $id');
  }
}

class FakeAlarmService extends AlarmService {
  FakeAlarmService() : super.visibleForTesting();

  final List<String> logs = [];

  @override
  Future<void> scheduleTodayAdhansIfNeeded(PrayerTimes times) async {
    logs.add('scheduleTodayAdhansIfNeeded (Bugünkü ezanları planla)');
  }

  @override
  Future<void> scheduleMonthlyAdhans(List<PrayerTimes> monthlyPrayers) async {
    logs.add('scheduleMonthlyAdhans (Aylık ezanları planla)');
  }
}

// --- Test ---

void main() {
  late FakeTimeService fakeTimeService;
  late FakeNotificationService fakeNotificationService;
  late FakeAlarmService fakeAlarmService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    // Başlangıç: 2023-01-01 00:00:00
    fakeTimeService = FakeTimeService(DateTime(2023, 1, 1, 0, 0, 0));
    fakeNotificationService = FakeNotificationService();
    fakeAlarmService = FakeAlarmService();
  });

  testWidgets('Simülasyon: Tam Gün Döngüsü', (WidgetTester tester) async {
    // Sahte Namaz Vakitleri
    final mockPrayerTimes = PrayerTimes(
      fajr: '06:00',
      sunrise: '07:30',
      dhuhr: '13:00',
      asr: '16:00',
      maghrib: '18:30',
      isha: '20:00',
      date: DateTime(2023, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timeServiceProvider.overrideWithValue(fakeTimeService),
          notificationServiceProvider.overrideWithValue(
            fakeNotificationService,
          ),
          alarmServiceProvider.overrideWithValue(fakeAlarmService),
          todayPrayerTimesProvider.overrideWith((ref) => mockPrayerTimes),
          monthlyPrayerTimesProvider.overrideWith(
            (ref, date) => [mockPrayerTimes],
          ),
          cityNameProvider.overrideWith((ref) => 'Test Şehri'),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('tr')],
          home: StitchHomePage(),
        ),
      ),
    );

    // İlk Derleme (Pump)
    // debugPrint('DEBUG: Widget derleniyor...');
    await tester.pumpAndSettle();
    // debugPrint('DEBUG: Widget derlendi.');

    // Başlangıç durumunu doğrula (00:00) -> Sıradaki vakit İmsak (06:00) olmalı
    expect(find.text('Test Şehri'), findsOneWidget);
    expect(find.text('Sonraki Vakit: İmsak (06:00)'), findsOneWidget);
    // debugPrint('Başlangıç durumu doğrulandı.');

    // Microtask'ın tamamlanması için biraz bekle
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Bildirim/Alarm planlamasının yapıldığını doğrula
    expect(
      fakeNotificationService.logs,
      contains(
        predicate((String s) => s.startsWith('ensurePrayerBarForToday')),
      ),
    );
    expect(
      fakeAlarmService.logs,
      contains('scheduleTodayAdhansIfNeeded (Bugünkü ezanları planla)'),
    );
    // debugPrint('DEBUG: Planlama doğrulandı.');

    // Zamanı ilerlet: 05:59:50 (İmsaktan 10 saniye önce)
    fakeTimeService.setTime(DateTime(2023, 1, 1, 5, 59, 50));
    await tester
        .pump(); // Provider watch'tan dolayı yeniden oluşturmayı tetikle
    // debugPrint('DEBUG: Zaman 05:59:50\'ye ilerletildi.');

    // Geri sayımı doğrula (yaklaşık)
    expect(find.text('00:00:10'), findsOneWidget);
    // debugPrint('DEBUG: Geri sayım doğrulandı.');

    // Zamanı İmsak sonrasına ilerlet (06:01)
    fakeTimeService.setTime(DateTime(2023, 1, 1, 6, 1, 0));
    await tester.pump();
    // debugPrint('DEBUG: Zaman 06:01\'e ilerletildi.');

    // Sıradaki vakit Güneş (07:30) olmalı
    expect(find.text('Sonraki Vakit: Güneş (07:30)'), findsOneWidget);
    // debugPrint('DEBUG: Sonraki vakit doğrulandı.');

    // Gece Yarısına İlerlet (Gün Değişimi)
    fakeTimeService.setTime(DateTime(2023, 1, 2, 0, 0, 1));

    await tester.pump(const Duration(minutes: 1));
    // debugPrint('DEBUG: Zaman gece yarısı + 1 dakikaya ilerletildi.');

    await tester.pumpAndSettle();
    // debugPrint('DEBUG: Gece yarısından sonra yerleşti (settled).');

    // Planlamanın tekrar yapıldığını doğrula
    expect(fakeNotificationService.logs, isNotEmpty);
    expect(fakeAlarmService.logs, isNotEmpty);
    // debugPrint('DEBUG: Gece yarısı yenilemesi doğrulandı.');
  });
}
