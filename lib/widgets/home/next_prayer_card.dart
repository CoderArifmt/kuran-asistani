import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/prayer_times.dart';
import '../../services/time_service.dart';
import '../../l10n/app_localizations.dart';

class NextPrayerCard extends ConsumerStatefulWidget {
  const NextPrayerCard({super.key, required this.times});

  final PrayerTimes times;

  @override
  ConsumerState<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends ConsumerState<NextPrayerCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final now = ref.watch(timeServiceProvider).now;

    // Helper to parse time string like "18:30"
    DateTime? parseTimeStr(String hm, {int dayOffset = 0}) {
      final match = RegExp(r'(\d{1,2}):(\d{1,2})').firstMatch(hm);
      if (match != null) {
        final h = int.tryParse(match.group(1)!) ?? 0;
        final m = int.tryParse(match.group(2)!) ?? 0;

        // API'den gelen tarih bazen hatalı olabiliyor (yarın vs).
        // Bu yüzden her zaman cihazın "bugün" tarihini baz alıyoruz.
        final today = DateTime(now.year, now.month, now.day);
        final targetDate = today.add(Duration(days: dayOffset));

        return DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          h,
          m,
        );
      }
      return null;
    }

    final prayerNameMap = {
      'fajr': loc.imsak,
      'sunrise': loc.gunes,
      'dhuhr': loc.ogle,
      'asr': loc.ikindi,
      'maghrib': loc.aksam,
      'isha': loc.yatsi,
    };

    final prayerEntries =
        <_PrayerTimeEntry>[
              _PrayerTimeEntry('fajr', parseTimeStr(widget.times.fajr)),
              _PrayerTimeEntry('sunrise', parseTimeStr(widget.times.sunrise)),
              _PrayerTimeEntry('dhuhr', parseTimeStr(widget.times.dhuhr)),
              _PrayerTimeEntry('asr', parseTimeStr(widget.times.asr)),
              _PrayerTimeEntry('maghrib', parseTimeStr(widget.times.maghrib)),
              _PrayerTimeEntry('isha', parseTimeStr(widget.times.isha)),
              _PrayerTimeEntry(
                'fajr_tomorrow',
                parseTimeStr(widget.times.fajr, dayOffset: 1),
              ),
              _PrayerTimeEntry(
                'sunrise_tomorrow',
                parseTimeStr(widget.times.sunrise, dayOffset: 1),
              ),
              _PrayerTimeEntry(
                'dhuhr_tomorrow',
                parseTimeStr(widget.times.dhuhr, dayOffset: 1),
              ),
              _PrayerTimeEntry(
                'asr_tomorrow',
                parseTimeStr(widget.times.asr, dayOffset: 1),
              ),
              _PrayerTimeEntry(
                'maghrib_tomorrow',
                parseTimeStr(widget.times.maghrib, dayOffset: 1),
              ),
              _PrayerTimeEntry(
                'isha_tomorrow',
                parseTimeStr(widget.times.isha, dayOffset: 1),
              ),
            ]
            .where((e) => e.time != null)
            .map((e) => _PrayerTimeEntry(e.key, e.time!))
            .toList();

    prayerEntries.sort((a, b) => a.time!.compareTo(b.time!));

    _PrayerTimeEntry? nextEntry;
    for (final entry in prayerEntries) {
      if (entry.time!.isAfter(now)) {
        nextEntry = entry;
        break;
      }
    }

    if (nextEntry == null) {
      // Fallback: Eğer uygun vakit bulunamazsa (çok eski veri), kartı yine de göster ama tire koy.
      // Kullanıcı "kaldırmanı istemiyorum" dediği için boş döndürmüyoruz.
      return _buildCard(
        context,
        nextPrayerName: '---',
        nextClock: '--:--',
        hours: 0,
        minutes: 0,
        seconds: 0,
        isError: true,
      );
    }

    final nextPrayerKey = nextEntry.key.replaceFirst('_tomorrow', '');
    final nextPrayerName = prayerNameMap[nextPrayerKey] ?? '';
    final nextPrayerTime = nextEntry.time!;

    final diff = nextPrayerTime.difference(now);

    // Negatif kontrolü: Eğer negatifse 00:00:00 göster (kartı gizleme)
    if (diff.isNegative) {
      return _buildCard(
        context,
        nextPrayerName: nextPrayerName,
        nextClock: '--:--',
        hours: 0,
        minutes: 0,
        seconds: 0,
      );
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);

    String two(int v) => v.toString().padLeft(2, '0');
    final nextClock =
        '${two(nextPrayerTime.hour)}:${two(nextPrayerTime.minute)}';

    return _buildCard(
      context,
      nextPrayerName: nextPrayerName,
      nextClock: nextClock,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String nextPrayerName,
    required String nextClock,
    required int hours,
    required int minutes,
    required int seconds,
    bool isError = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String two(int v) => v.toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                size: 18,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                '${AppLocalizations.of(context).nextPrayer}: $nextPrayerName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                ' ($nextClock)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Gradient Countdown Text
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color(0xFF34D399), Color(0xFF6EE7B7)],
              ).createShader(bounds);
            },
            child: Text(
              '${two(hours)}:${two(minutes)}:${two(seconds)}',
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'kaldı', // Or localize this if available
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerTimeEntry {
  final String key;
  final DateTime? time;

  _PrayerTimeEntry(this.key, this.time);
}
