import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/prayer_times.dart';
import '../providers/app_providers.dart';
import '../services/notification_service.dart';
import '../services/alarm_service.dart';
import '../l10n/app_localizations.dart';
import 'settings_page.dart';

// Provider to cache last scheduled date to prevent duplicate scheduling
final _lastScheduledDateProvider = StateProvider<DateTime?>((ref) => null);

class StitchHomePage extends ConsumerWidget {
  const StitchHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final asyncTimes = ref.watch(todayPrayerTimesProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.mosque, size: 28),
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).appName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Expanded(
                  child: asyncTimes.when(
                    loading: () => const _HomeLoading(),
                    error: (e, _) => _HomeError(message: e.toString()),
                    data: (times) {
                      // Bildirimleri sadece bir kez planlamak için bugünün (cihaz) tarihini kullan
                      final lastScheduled = ref.read(
                        _lastScheduledDateProvider,
                      );
                      final now = DateTime.now();
                      final currentDate = DateTime(
                        now.year,
                        now.month,
                        now.day,
                      );

                      if (lastScheduled == null ||
                          lastScheduled.day != currentDate.day ||
                          lastScheduled.month != currentDate.month ||
                          lastScheduled.year != currentDate.year) {
                        // Bildirimleri arka planda zamanla
                        Future.microtask(() async {
                          await AlarmService.instance
                              .scheduleTodayAdhansIfNeeded(times);

                          if (!context.mounted) return;
                          final l10n = AppLocalizations.of(context);
                          final title = l10n.todaysPrayerTimes;
                          final body =
                              '${l10n.fajr} ${times.fajr}  |  ${l10n.dhuhr} ${times.dhuhr}  |  ${l10n.maghrib} ${times.maghrib}';
                          final bigText =
                              '${l10n.fajr} ${times.fajr}  |  ${l10n.sunrise} ${times.sunrise}  |  ${l10n.dhuhr} ${times.dhuhr}\n'
                              '${l10n.asr} ${times.asr}  |  ${l10n.maghrib} ${times.maghrib}  |  ${l10n.isha} ${times.isha}';
                          final summaryText =
                              '${l10n.sunrise} ${times.sunrise}  |  ${l10n.asr} ${times.asr}';

                          await NotificationService.instance
                              .ensurePrayerBarForToday(
                                times: times,
                                title: title,
                                body: body,
                                bigText: bigText,
                                summaryText: summaryText,
                              );

                          // Bu oturum içinde bugünün tarihini hatırla
                          ref.read(_lastScheduledDateProvider.notifier).state =
                              currentDate;
                        });
                      }

                      return _HomeContent(times: times);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context).prayerTimesLoading),
        ],
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.red.withValues(alpha: 0.15)
                : Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${AppLocalizations.of(context).errorLoadingTimes}\n$message',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.times});

  final PrayerTimes times;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cityAsync = ref.watch(cityNameProvider);
    final cityName =
        cityAsync.value ?? AppLocalizations.of(context).locationAuto;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Location & date (dummy city / today)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.5)
                        : const Color(0xFFE5E7EB).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.05,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).yourLocation,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cityName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(context, times.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Sonraki vakit kartı (gerçek veri + geri sayım)
                _NextPrayerCard(times: times),
                const SizedBox(height: 12),
                _PrayerRow(
                  label: AppLocalizations.of(context).imsak,
                  time: times.fajr,
                  state: _getPrayerState(times, 'fajr'),
                ),
                _PrayerRow(
                  label: AppLocalizations.of(context).gunes,
                  time: times.sunrise,
                  state: _getPrayerState(times, 'sunrise'),
                ),
                _PrayerRow(
                  label: AppLocalizations.of(context).ogle,
                  time: times.dhuhr,
                  state: _getPrayerState(times, 'dhuhr'),
                ),
                _PrayerRow(
                  label: AppLocalizations.of(context).ikindi,
                  time: times.asr,
                  state: _getPrayerState(times, 'asr'),
                ),
                _PrayerRow(
                  label: AppLocalizations.of(context).aksam,
                  time: times.maghrib,
                  state: _getPrayerState(times, 'maghrib'),
                ),
                _PrayerRow(
                  label: AppLocalizations.of(context).yatsi,
                  time: times.isha,
                  state: _getPrayerState(times, 'isha'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final months = AppLocalizations.of(context).monthNames;
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  /// Verilen vakit için mevcut durumu (geçmiş/şu an/gelecek) hesaplar.
  PrayerRowState _getPrayerState(PrayerTimes times, String prayerKey) {
    final now = DateTime.now();

    DateTime? parseTime(String timeStr, {int dayOffset = 0}) {
      final match = RegExp(r'(\d{1,2}):(\d{1,2})').firstMatch(timeStr);
      if (match != null) {
        final h = int.tryParse(match.group(1)!) ?? 0;
        final m = int.tryParse(match.group(2)!) ?? 0;
        final targetDate = times.date.add(Duration(days: dayOffset));
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

    final prayerEntries =
        <_PrayerTimeEntry>[
              _PrayerTimeEntry('fajr', parseTime(times.fajr)),
              _PrayerTimeEntry('sunrise', parseTime(times.sunrise)),
              _PrayerTimeEntry('dhuhr', parseTime(times.dhuhr)),
              _PrayerTimeEntry('asr', parseTime(times.asr)),
              _PrayerTimeEntry('maghrib', parseTime(times.maghrib)),
              _PrayerTimeEntry('isha', parseTime(times.isha)),
              // Add tomorrow's Fajr for comparison
              _PrayerTimeEntry(
                'fajr_tomorrow',
                parseTime(times.fajr, dayOffset: 1),
              ),
            ]
            .where((e) => e.time != null)
            .map((e) => _PrayerTimeEntry(e.key, e.time!))
            .toList();

    // Sort entries by time
    prayerEntries.sort((a, b) => a.time!.compareTo(b.time!));

    String? currentPrayerKey;
    String? nextPrayerKey;

    // Find the next prayer
    for (int i = 0; i < prayerEntries.length; i++) {
      if (prayerEntries[i].time!.isAfter(now)) {
        nextPrayerKey = prayerEntries[i].key.replaceFirst('_tomorrow', '');

        // The prayer before the next one is the current one
        if (i > 0) {
          currentPrayerKey = prayerEntries[i - 1].key.replaceFirst(
            '_tomorrow',
            '',
          );
        } else {
          // If the first entry (Fajr) is next, then current is Isha (from yesterday)
          currentPrayerKey = 'isha';
        }
        break;
      }
    }

    // If no next prayer found (all passed), then current is Isha, next is Fajr (tomorrow)
    if (nextPrayerKey == null && prayerEntries.isNotEmpty) {
      currentPrayerKey = 'isha';
      nextPrayerKey = 'fajr';
    }

    if (prayerKey == currentPrayerKey) {
      return PrayerRowState.current;
    } else if (prayerKey == nextPrayerKey) {
      return PrayerRowState.future;
    } else {
      return PrayerRowState.past;
    }
  }
}

enum PrayerRowState { past, current, future }

class _PrayerTimeEntry {
  final String key;
  final DateTime? time;

  _PrayerTimeEntry(this.key, this.time);
}

class _NextPrayerCard extends StatefulWidget {
  const _NextPrayerCard({required this.times});

  final PrayerTimes times;

  @override
  State<_NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<_NextPrayerCard> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    // Helper to parse time string like "18:30"
    DateTime? parseTimeStr(String hm, {int dayOffset = 0}) {
      final match = RegExp(r'(\d{1,2}):(\d{1,2})').firstMatch(hm);
      if (match != null) {
        final h = int.tryParse(match.group(1)!) ?? 0;
        final m = int.tryParse(match.group(2)!) ?? 0;

        // API'den gelen tarih bazen hatalı olabiliyor (yarın vs).
        // Bu yüzden her zaman cihazın "bugün" tarihini baz alıyoruz.
        final now = DateTime.now();
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
      if (entry.time!.isAfter(_now)) {
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

    final diff = nextPrayerTime.difference(_now);

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
          Text(
            '${AppLocalizations.of(context).nextPrayer}: $nextPrayerName ($nextClock)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isError
                ? '--:--:--'
                : '${two(hours)}:${two(minutes)}:${two(seconds)}',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14B866),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.label,
    required this.time,
    required this.state,
  });

  final String label;
  final String time;
  final PrayerRowState state;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg = Colors.transparent;
    Color iconBg = Colors.transparent;
    Color iconColor = Colors.white;
    Color textColor = Colors.white;
    Color timeColor = Colors.white;
    double opacity = 1.0;
    BoxBorder? border;

    switch (state) {
      case PrayerRowState.past:
      case PrayerRowState.current:
        bg = isDark
            ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5)
            : const Color(0xFFE5E7EB).withValues(alpha: 0.5);
        iconBg = isDark ? const Color(0xFF374151) : const Color(0xFFD1D5DB);
        iconColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
        textColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280);
        timeColor = textColor;
        opacity = 0.6;
        break;
      case PrayerRowState.future:
        bg = isDark
            ? const Color(0xFF14B866).withValues(alpha: 0.3)
            : const Color(0xFF14B866).withValues(alpha: 0.2);
        iconBg = const Color(0xFF14B866);
        iconColor = Colors.white;
        textColor = isDark ? Colors.white : const Color(0xFF111827);
        timeColor = textColor;
        border = Border.all(color: const Color(0xFF14B866), width: 2);
        break;
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: border,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconForLabel(label), size: 24, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: state == PrayerRowState.future
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: state == PrayerRowState.future
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: timeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    switch (label) {
      case 'İmsak':
        return Icons.stars;
      case 'Güneş':
      case 'Öğle':
        return Icons.light_mode;
      case 'İkindi':
        return Icons.flare;
      case 'Akşam':
        return Icons.nights_stay;
      case 'Yatsı':
        return Icons.dark_mode;
      default:
        return Icons.star;
    }
  }
}
