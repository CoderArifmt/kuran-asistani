import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

class MoreIslamicCalendarPage extends ConsumerStatefulWidget {
  const MoreIslamicCalendarPage({super.key});

  @override
  ConsumerState<MoreIslamicCalendarPage> createState() =>
      _MoreIslamicCalendarPageState();
}

class _MoreIslamicCalendarPageState
    extends ConsumerState<MoreIslamicCalendarPage> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  String _monthNameTr(int month) {
    const names = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return names[month - 1];
  }

  String _hijriMonthName(int month) {
    const names = [
      'Muharrem',
      'Safer',
      'Rebiülevvel',
      'Rebiülahir',
      'Cemaziyelevvel',
      'Cemaziyelahir',
      'Recep',
      'Şaban',
      'Ramazan',
      'Şevval',
      'Zilkade',
      'Zilhicce',
    ];
    return names[(month - 1).clamp(0, 11)];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asyncTodayTimes = ref.watch(todayPrayerTimesProvider);
    final asyncMonth = ref.watch(monthlyPrayerTimesProvider(_currentMonth));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Header
                Container(
                  height: 56,
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                      Expanded(
                        child: Text(
                          'İslami Takvim',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF18181B),
                              ),
                        ),
                      ),
                      const SizedBox(width: 48, height: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Text(
                        'Hicri takvim ve önemli günler',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bulunduğun şehre göre günlük hicri tarih ve aylık namaz takvimi Aladhan servisinden alınır.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF111827)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.25 : 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF14B866,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.event,
                                    color: Color(0xFF14B866),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Bugün',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            asyncTodayTimes.when(
                              loading: () => Text(
                                'Miladi tarih: Yükleniyor...',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              error: (e, st) => Text(
                                'Miladi tarih: hata',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              data: (times) {
                                final miladi =
                                    '${times.date.day.toString().padLeft(2, '0')}.${times.date.month.toString().padLeft(2, '0')}.${times.date.year}';
                                final hicri = times.hijriDate ?? '--/--/----';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Miladi tarih: $miladi',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Hicri tarih: $hicri',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(
                                  _currentMonth.year,
                                  _currentMonth.month - 1,
                                );
                              });
                            },
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Column(
                            children: [
                              Text(
                                '${_monthNameTr(_currentMonth.month)} ${_currentMonth.year}',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              asyncMonth.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, st) => const SizedBox.shrink(),
                                data: (days) {
                                  if (days.isEmpty ||
                                      days.first.hijriDate == null) {
                                    return const SizedBox.shrink();
                                  }
                                  final parts = days.first.hijriDate!.split(
                                    '-',
                                  );
                                  final hijriMonth =
                                      int.tryParse(parts[1]) ?? 1;
                                  final hijriYear = parts.length > 2
                                      ? parts[2]
                                      : '';
                                  return Text(
                                    '${_hijriMonthName(hijriMonth)} $hijriYear H',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: isDark
                                              ? const Color(0xFF9CA3AF)
                                              : const Color(0xFF6B7280),
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(
                                  _currentMonth.year,
                                  _currentMonth.month + 1,
                                );
                              });
                            },
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      asyncMonth.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Aylık takvim yüklenemedi: $e'),
                        ),
                        data: (days) {
                          if (days.isEmpty) {
                            return const Text('Bu ay için veri bulunamadı');
                          }
                          return Column(
                            children: days.map((pt) {
                              final miladi =
                                  '${pt.date.day.toString().padLeft(2, '0')}.${pt.date.month.toString().padLeft(2, '0')}';
                              final hicri = pt.hijriDate ?? '--/--';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF020617)
                                      : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 72,
                                      child: Text(
                                        miladi,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Hicri: $hicri',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
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
