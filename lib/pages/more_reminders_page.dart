import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class MoreRemindersPage extends StatefulWidget {
  const MoreRemindersPage({super.key});

  @override
  State<MoreRemindersPage> createState() => _MoreRemindersPageState();
}

class _MoreRemindersPageState extends State<MoreRemindersPage> {
  bool _quranEnabled = false;
  TimeOfDay _quranTime = const TimeOfDay(hour: 20, minute: 0);
  bool _nightDuaEnabled = false;
  TimeOfDay _nightDuaTime = const TimeOfDay(hour: 22, minute: 0);

  static const _quranId = 2001;
  static const _nightDuaId = 2002;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _quranEnabled = prefs.getBool('reminder_quran_enabled') ?? false;
      _nightDuaEnabled = prefs.getBool('reminder_nightdua_enabled') ?? false;
      final qHour = prefs.getInt('reminder_quran_hour');
      final qMin = prefs.getInt('reminder_quran_min');
      if (qHour != null && qMin != null) {
        _quranTime = TimeOfDay(hour: qHour, minute: qMin);
      }
      final nHour = prefs.getInt('reminder_nightdua_hour');
      final nMin = prefs.getInt('reminder_nightdua_min');
      if (nHour != null && nMin != null) {
        _nightDuaTime = TimeOfDay(hour: nHour, minute: nMin);
      }
    });
  }

  Future<void> _setQuranReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled) {
      if (!mounted) return;
      final picked = await showTimePicker(
        context: context,
        initialTime: _quranTime,
      );
      if (picked == null || !mounted) return;
      setState(() {
        _quranEnabled = true;
        _quranTime = picked;
      });
      await prefs.setBool('reminder_quran_enabled', true);
      await prefs.setInt('reminder_quran_hour', picked.hour);
      await prefs.setInt('reminder_quran_min', picked.minute);
      await NotificationService.instance.scheduleDailyReminder(
        id: _quranId,
        title: 'Günlük Kur\'an hatırlatıcısı',
        body: 'Bugün için kısa bir Kur\'an okumayı unutma.',
        time: picked,
      );
    } else {
      if (!mounted) return;
      setState(() {
        _quranEnabled = false;
      });
      await prefs.setBool('reminder_quran_enabled', false);
      await NotificationService.instance.cancelReminder(_quranId);
    }
  }

  Future<void> _setNightDuaReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled) {
      if (!mounted) return;
      final picked = await showTimePicker(
        context: context,
        initialTime: _nightDuaTime,
      );
      if (picked == null || !mounted) return;
      setState(() {
        _nightDuaEnabled = true;
        _nightDuaTime = picked;
      });
      await prefs.setBool('reminder_nightdua_enabled', true);
      await prefs.setInt('reminder_nightdua_hour', picked.hour);
      await prefs.setInt('reminder_nightdua_min', picked.minute);
      await NotificationService.instance.scheduleDailyReminder(
        id: _nightDuaId,
        title: 'Gece duası hatırlatıcısı',
        body: 'Yatsıdan sonra kısa bir dua için zaman ayır.',
        time: picked,
      );
    } else {
      if (!mounted) return;
      setState(() {
        _nightDuaEnabled = false;
      });
      await prefs.setBool('reminder_nightdua_enabled', false);
      await NotificationService.instance.cancelReminder(_nightDuaId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                          'Hatırlatıcılar',
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
                        'Kur\'an ve dua hatırlatmaları',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gün içinde Kur\'an okumayı, dua etmeyi veya tesbih çekmeyi unutuyorsan, buradan günlük veya haftalık hatırlatmalar planlayabilirsin.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          color: isDark
                              ? const Color(0xFFD1D5DB)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile.adaptive(
                        title: const Text('Günlük Kur\'an hatırlatıcısı'),
                        subtitle: Text(
                          'Her gün ${_quranTime.format(context)} saatinde kısa bir Kur\'an hatırlatması.',
                        ),
                        value: _quranEnabled,
                        onChanged: (v) => _setQuranReminder(v),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        title: const Text('Gece duası hatırlatıcısı'),
                        subtitle: Text(
                          'Her gün ${_nightDuaTime.format(context)} saatinde gece duası hatırlatması.',
                        ),
                        value: _nightDuaEnabled,
                        onChanged: (v) => _setNightDuaReminder(v),
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
