import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../l10n/app_localizations.dart';
import 'dart:async';

class RamadanPage extends ConsumerStatefulWidget {
  const RamadanPage({super.key});

  @override
  ConsumerState<RamadanPage> createState() => _RamadanPageState();
}

class _RamadanPageState extends ConsumerState<RamadanPage>
    with AutomaticKeepAliveClientMixin {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asyncTimes = ref.watch(todayPrayerTimesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).ramadan,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: asyncTimes.when(
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context).loading),
                    ],
                  ),
                ),
                error: (e, _) => Center(
                  child: Text('${AppLocalizations.of(context).error}: $e'),
                ),
                data: (times) {
                  final fajrTime = _parseTime(times.fajr);
                  final maghribTime = _parseTime(times.maghrib);

                  final sahurCountdown = _getCountdown(fajrTime);
                  final iftarCountdown = _getCountdown(maghribTime);

                  final isFasting =
                      _now.isAfter(fajrTime) && _now.isBefore(maghribTime);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Ramazan Icon (RepaintBoundary for optimization)
                        RepaintBoundary(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF14B866,
                              ).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.nightlight_round,
                              size: 64,
                              color: Color(0xFF14B866),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Status Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1C2C24)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                            children: [
                              Text(
                                isFasting
                                    ? AppLocalizations.of(context).fasting
                                    : AppLocalizations.of(context).notFasting,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isFasting
                                      ? const Color(0xFF14B866)
                                      : (isDark
                                            ? Colors.white70
                                            : Colors.grey.shade600),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isFasting
                                    ? AppLocalizations.of(context).untilIftar
                                    : AppLocalizations.of(context).untilSuhoor,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sahur Card
                        _TimeCard(
                          title: AppLocalizations.of(context).suhoorFajr,
                          time: times.fajr,
                          countdown: sahurCountdown,
                          icon: Icons.wb_twilight,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),

                        // Iftar Card
                        _TimeCard(
                          title: AppLocalizations.of(context).iftarMaghrib,
                          time: times.maghrib,
                          countdown: iftarCountdown,
                          icon: Icons.dinner_dining,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // Tips Card (RepaintBoundary - static content)
                        RepaintBoundary(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF14B866,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Builder(
                              builder: (context) {
                                final tips = _localizedRamadanTips(context);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.tips_and_updates,
                                          color: Color(0xFF14B866),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          ).ramadanAdvice,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF14B866),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ...tips.map(
                                      (tip) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '• ',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Expanded(
                                              child: Text(
                                                tip,
                                                style: const TextStyle(
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final h = int.tryParse(parts[0].trim()) ?? 0;
    final minutePart = parts.length > 1
        ? parts[1].trim().split(' ').first
        : '0';
    final m = int.tryParse(minutePart) ?? 0;
    return DateTime(_now.year, _now.month, _now.day, h, m);
  }

  String _getCountdown(DateTime targetTime) {
    var diff = targetTime.difference(_now);
    if (diff.isNegative) {
      diff = targetTime.add(const Duration(days: 1)).difference(_now);
    }
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.title,
    required this.time,
    required this.countdown,
    required this.icon,
    required this.isDark,
  });

  final String title;
  final String time;
  final String countdown;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2C24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF14B866).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF14B866)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14B866),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  countdown,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> _ramadanTips = [
  'Sahurda bol su için ve hafif yiyecekler tercih edin',
  'İftar açarken acele etmeyin, mideyi yavaş alıştırın',
  'Teravih namazını kaçırmamaya özen gösterin',
  'Kur\'an-ı Kerim okumaya zaman ayırın',
  'Sadaka ve yardımlaşmayı unutmayın',
  'Fazla yağlı ve ağır yemeklerden kaçının',
];

/// Localize Ramadan tips based on current locale.
List<String> _localizedRamadanTips(BuildContext context) {
  final lang = Localizations.localeOf(context).languageCode;
  if (lang != 'en') return _ramadanTips;
  return const [
    'Drink plenty of water at suhoor and choose light foods.',
    'Do not rush when breaking your fast; let your stomach adjust slowly.',
    'Try not to miss Taraweeh prayers.',
    'Make time to read the Qur\'an regularly.',
    'Do not forget charity and helping those in need.',
    'Avoid overly fatty and heavy meals.',
  ];
}
