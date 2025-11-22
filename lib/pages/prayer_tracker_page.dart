import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'dart:convert';

class PrayerTrackerPage extends StatefulWidget {
  const PrayerTrackerPage({super.key});

  @override
  State<PrayerTrackerPage> createState() => _PrayerTrackerPageState();
}

class _PrayerTrackerPageState extends State<PrayerTrackerPage> {
  Map<String, Map<String, bool>> _prayerData = {};
  late String _todayKey;

  final List<String> _prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  @override
  void initState() {
    super.initState();
    _todayKey = _getDateKey(DateTime.now());
    _loadData();
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('prayer_tracker_data');
    if (jsonStr != null) {
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      setState(() {
        _prayerData = decoded.map(
          (key, value) => MapEntry(key, Map<String, bool>.from(value as Map)),
        );
      });
    }
    // Bugünün verisi yoksa oluştur
    if (!_prayerData.containsKey(_todayKey)) {
      _prayerData[_todayKey] = {for (var p in _prayers) p: false};
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_tracker_data', json.encode(_prayerData));
  }

  void _togglePrayer(String prayer) {
    setState(() {
      _prayerData[_todayKey]![prayer] =
          !(_prayerData[_todayKey]![prayer] ?? false);
    });
    _saveData();
  }

  int _getTodayCount() {
    return _prayerData[_todayKey]?.values.where((v) => v).length ?? 0;
  }

  int _getWeekCount() {
    final now = DateTime.now();
    int count = 0;
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(const Duration(days: 1));
      final key = _getDateKey(date);
      count += _prayerData[key]?.values.where((v) => v).length ?? 0;
    }
    return count;
  }

  String _getPrayerLabel(BuildContext context, String prayerKey) {
    final l10n = AppLocalizations.of(context);
    switch (prayerKey.toLowerCase()) {
      case 'fajr':
        return l10n.fajr;
      case 'dhuhr':
        return l10n.dhuhr;
      case 'asr':
        return l10n.asr;
      case 'maghrib':
        return l10n.maghrib;
      case 'isha':
        return l10n.isha;
      default:
        return prayerKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayCount = _getTodayCount();
    final weekCount = _getWeekCount();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                      AppLocalizations.of(context).prayerTracker,
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

            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: AppLocalizations.of(context).today,
                      value: '$todayCount/5',
                      icon: Icons.today,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: AppLocalizations.of(context).thisWeek,
                      value: '$weekCount/35',
                      icon: Icons.calendar_month,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),

            // Prayer List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _prayers.length,
                itemBuilder: (context, index) {
                  final prayerKey = _prayers[index];
                  final displayName = _getPrayerLabel(context, prayerKey);
                  final isCompleted =
                      _prayerData[_todayKey]?[prayerKey] ?? false;
                  return _PrayerCheckItem(
                    prayer: displayName,
                    isCompleted: isCompleted,
                    onTap: () => _togglePrayer(prayerKey),
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF14B866), size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14B866),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerCheckItem extends StatelessWidget {
  const _PrayerCheckItem({
    required this.prayer,
    required this.isCompleted,
    required this.onTap,
    required this.isDark,
  });

  final String prayer;
  final bool isCompleted;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFF14B866).withValues(alpha: 0.1)
            : (isDark ? const Color(0xFF1C2C24) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: isCompleted
            ? Border.all(color: const Color(0xFF14B866), width: 2)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF14B866)
                : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.mosque,
            color: isCompleted
                ? Colors.white
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
            size: 24,
          ),
        ),
        title: Text(
          prayer,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isCompleted ? const Color(0xFF14B866) : null,
          ),
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Color(0xFF14B866), size: 28)
            : null,
        onTap: onTap,
      ),
    );
  }
}
