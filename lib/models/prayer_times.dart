class PrayerTimes {
  final DateTime date;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  /// Örneğin "13-05-1446" gibi Aladhan hijri tarihi (opsiyonel).
  final String? hijriDate;

  PrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.hijriDate,
  });

  factory PrayerTimes.fromAladhan(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PrayerTimes.fromAladhanDay(data);
  }

  /// Aladhan API'sinden tek bir günün "data" girdisinden PrayerTimes üretir.
  factory PrayerTimes.fromAladhanDay(Map<String, dynamic> data) {
    final timings = data['timings'] as Map<String, dynamic>;
    final dateData = data['date'] as Map<String, dynamic>;
    final dateInfo = dateData['gregorian'] as Map<String, dynamic>;
    final hijriInfo = dateData['hijri'] as Map<String, dynamic>?;

    final dateParts = (dateInfo['date'] as String).split('-'); // "15-11-2025"
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);

    final hijriDate = hijriInfo != null ? hijriInfo['date'] as String? : null;

    return PrayerTimes(
      date: DateTime(year, month, day),
      fajr: timings['Fajr'] as String,
      sunrise: timings['Sunrise'] as String,
      dhuhr: timings['Dhuhr'] as String,
      asr: timings['Asr'] as String,
      maghrib: timings['Maghrib'] as String,
      isha: timings['Isha'] as String,
      hijriDate: hijriDate,
    );
  }

  String getPrayerTime(String prayerKey) {
    switch (prayerKey) {
      case 'fajr':
        return fajr;
      case 'sunrise':
        return sunrise;
      case 'dhuhr':
        return dhuhr;
      case 'asr':
        return asr;
      case 'maghrib':
        return maghrib;
      case 'isha':
        return isha;
      default:
        return '';
    }
  }
}
