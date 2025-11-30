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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF14B866).withValues(alpha: 0.2)
            : const Color(0xFF14B866).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${AppLocalizations.of(context).nextPrayer}: $nextPrayerName ($nextClock)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFFE5E7EB)
                    : const Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${two(hours)}:${two(minutes)}:${two(seconds)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFF14B866)
                    : const Color(0xFF10B981),
              ),
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
