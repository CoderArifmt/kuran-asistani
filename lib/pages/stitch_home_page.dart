import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prayer_times.dart';
import '../providers/app_providers.dart';

import '../services/time_service.dart';
import '../l10n/app_localizations.dart';
import 'settings_page.dart';

import '../widgets/home/next_prayer_card.dart';
import '../widgets/home/prayer_row.dart';

// Provider to cache last scheduled date to prevent duplicate scheduling
final _lastScheduledDateProvider = StateProvider<DateTime?>((ref) => null);

class StitchHomePage extends ConsumerStatefulWidget {
  const StitchHomePage({super.key});

  @override
  ConsumerState<StitchHomePage> createState() => StitchHomePageState();
}

class StitchHomePageState extends ConsumerState<StitchHomePage> {
  Timer? _dayCheckTimer;
  int? _lastDay;

  @override
  void initState() {
    super.initState();
    _lastDay = ref.read(timeServiceProvider).now.day;
    // Check every minute if the day has changed
    _dayCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = ref.read(timeServiceProvider).now;
      if (now.day != _lastDay) {
        _lastDay = now.day;
        // Refresh prayer times for the new day
        ref.invalidate(todayPrayerTimesProvider);
        // Reset scheduling state to ensure notifications are rescheduled
        ref.read(_lastScheduledDateProvider.notifier).state = null;
      }
    });
  }

  @override
  void dispose() {
    _dayCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncTimes = ref.watch(todayPrayerTimesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Ana Gradyan Arka Plan
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          const Color(0xFF064E3B), // Dark Emerald
                          const Color(0xFF022C22), // Deepest Emerald
                          Colors.black,
                        ]
                      : [
                          const Color(0xFF10B981), // Emerald 500
                          const Color(0xFF065F46), // Emerald 800
                          const Color(0xFF064E3B), // Emerald 900
                        ],
                ),
              ),
            ),
          ),
          // 2. İslami Desen Katmanı (Düşük Opasite)
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.08 : 0.12,
              child: Image.asset(
                'assets/images/islamic_pattern.png',
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          // 3. İçerik
          SafeArea(
            child: Column(
              children: [
                // Modern Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).appName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            height: 3,
                            width: 40,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF34D399),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Body content
                Expanded(
                  child: asyncTimes.when(
                    loading: () => const _HomeLoading(),
                    error: (e, _) => _HomeError(message: e.toString()),
                    data: (times) {
                      // Bildirimleri sadece bir kez planlamak için bugünün (cihaz) tarihini kullan
                      final lastScheduled = ref.read(
                        _lastScheduledDateProvider,
                      );
                      final now = ref.read(timeServiceProvider).now;
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
                          // Check if we need monthly scheduling
                          final prefs = await SharedPreferences.getInstance();
                          final lastFullScheduleStr = prefs.getString(
                            'last_full_schedule_date',
                          );
                          final now = ref.read(timeServiceProvider).now;
                          final shouldScheduleMonthly =
                              lastFullScheduleStr == null ||
                              DateTime.parse(lastFullScheduleStr).month !=
                                  now.month ||
                              DateTime.parse(lastFullScheduleStr).year !=
                                  now.year;

                          if (shouldScheduleMonthly) {
                            // Schedule for entire month
                            try {
                              final monthlyTimes = await ref.read(
                                monthlyPrayerTimesProvider(
                                  DateTime(now.year, now.month, 1),
                                ).future,
                              );
                              await ref
                                  .read(alarmServiceProvider)
                                  .scheduleMonthlyAdhans(monthlyTimes);
                            } catch (e) {
                              debugPrint(
                                '[AdhanSchedule] Monthly schedule failed, falling back to today: $e',
                              );
                              // Fallback to today's schedule
                              await ref
                                  .read(alarmServiceProvider)
                                  .scheduleTodayAdhansIfNeeded(times);
                            }
                          } else {
                            // Just schedule for today
                            await ref
                                .read(alarmServiceProvider)
                                .scheduleTodayAdhansIfNeeded(times);
                          }

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

                          await ref
                              .read(notificationServiceProvider)
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

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _HomeContent(times: times),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> triggerMonthlySchedule({bool force = false}) async {
    final times = ref.read(todayPrayerTimesProvider).value;
    if (times != null) {
      await ref.read(alarmServiceProvider).scheduleTodayAdhansIfNeeded(times);
    }
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

    // Calculate current and next prayer keys once
    final now = ref.read(timeServiceProvider).now;
    final prayerStatus = _calculatePrayerStatus(times, now);

    return Column(
      children: [
        // Modern Location & Date Card (Glassmorphism)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF34D399),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(context, times.date),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Next Prayer Card
        NextPrayerCard(times: times),
        const SizedBox(height: 16),
        // Prayer Times List with Title
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).todaysPrayerTimes,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        PrayerRow(
          label: AppLocalizations.of(context).imsak,
          time: times.fajr,
          state: _getPrayerState('fajr', prayerStatus),
        ),
        PrayerRow(
          label: AppLocalizations.of(context).gunes,
          time: times.sunrise,
          state: _getPrayerState('sunrise', prayerStatus),
        ),
        PrayerRow(
          label: AppLocalizations.of(context).ogle,
          time: times.dhuhr,
          state: _getPrayerState('dhuhr', prayerStatus),
        ),
        PrayerRow(
          label: AppLocalizations.of(context).ikindi,
          time: times.asr,
          state: _getPrayerState('asr', prayerStatus),
        ),
        PrayerRow(
          label: AppLocalizations.of(context).aksam,
          time: times.maghrib,
          state: _getPrayerState('maghrib', prayerStatus),
        ),
        PrayerRow(
          label: AppLocalizations.of(context).yatsi,
          time: times.isha,
          state: _getPrayerState('isha', prayerStatus),
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final months = AppLocalizations.of(context).monthNames;
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  /// Calculates the current and next prayer keys based on the current time.
  ({String? current, String? next}) _calculatePrayerStatus(
    PrayerTimes times,
    DateTime now,
  ) {
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

    return (current: currentPrayerKey, next: nextPrayerKey);
  }

  PrayerRowState _getPrayerState(
    String prayerKey,
    ({String? current, String? next}) status,
  ) {
    if (prayerKey == status.current) {
      return PrayerRowState.current;
    } else if (prayerKey == status.next) {
      return PrayerRowState.future;
    } else {
      return PrayerRowState.past;
    }
  }
}

class _PrayerTimeEntry {
  final String key;
  final DateTime? time;

  _PrayerTimeEntry(this.key, this.time);
}
