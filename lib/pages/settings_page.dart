import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../theme/theme_mode_controller.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../services/alarm_service.dart';
import '../providers/app_providers.dart';
import '../providers/font_size_provider.dart';
import 'privacy_permissions_page.dart';
import 'more_location_page.dart';
import 'stitch_qibla_page.dart';
import 'about_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _prayerNotifications = true;
  bool _prayerBarEnabled = false;

  String _appVersion = '';
  String _buildNumber = '';

  static const _prefsKeyPrayerNotifications = 'prayer_notifications_enabled';
  static const _prefsKeyPrayerBar = 'prayer_bar_enabled';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prayerNotifications =
          prefs.getBool(_prefsKeyPrayerNotifications) ?? true;
      _prayerBarEnabled = prefs.getBool(_prefsKeyPrayerBar) ?? false;
    });
  }

  Future<void> _togglePrayerNotifications(bool value) async {
    setState(() => _prayerNotifications = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyPrayerNotifications, value);
    if (value) {
      await NotificationService.instance.requestPermission();
      final asyncTimes = ref.read(todayPrayerTimesProvider);
      asyncTimes.whenData((times) async {
        await AlarmService.instance.scheduleTodayAdhansIfNeeded(times);
      });
    } else {
      for (int i = 1; i <= 320; i++) {
        await NotificationService.instance.cancelReminder(i);
      }
      await NotificationService.instance.hidePrayerBar();
    }
  }

  Future<void> _togglePrayerBar(bool value) async {
    setState(() => _prayerBarEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyPrayerBar, value);
    final asyncTimes = ref.read(todayPrayerTimesProvider);
    asyncTimes.whenData((times) async {
      if (value) {
        final l10n = AppLocalizations.of(context);
        final title = l10n.todaysPrayerTimes;
        final body =
            '${l10n.fajr} ${times.fajr}  |  ${l10n.dhuhr} ${times.dhuhr}  |  ${l10n.maghrib} ${times.maghrib}';
        final bigText =
            '${l10n.fajr} ${times.fajr}  |  ${l10n.sunrise} ${times.sunrise}  |  ${l10n.dhuhr} ${times.dhuhr}\n'
            '${l10n.asr} ${times.asr}  |  ${l10n.maghrib} ${times.maghrib}  |  ${l10n.isha} ${times.isha}';
        final summaryText =
            '${l10n.sunrise} ${times.sunrise}  |  ${l10n.asr} ${times.asr}';

        await NotificationService.instance.ensurePrayerBarForToday(
          times: times,
          title: title,
          body: body,
          bigText: bigText,
          summaryText: summaryText,
        );
      } else {
        await NotificationService.instance.hidePrayerBar();
      }
    });
  }

  Future<void> _resetNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 1; i <= 320; i++) {
      await NotificationService.instance.cancelReminder(i);
    }

    await prefs.setBool('adhan_master', true);
    await prefs.setBool('prayer_notifications_enabled', true);
    await prefs.setBool('adhan_fajr', true);
    await prefs.setBool('adhan_dhuhr', true);
    await prefs.setBool('adhan_asr', true);
    await prefs.setBool('adhan_maghrib', true);
    await prefs.setBool('adhan_isha', true);
    await prefs.setBool('prayer_bar_enabled', false);

    await _loadSettings();

    await NotificationService.instance.requestPermission();
    final asyncTimes = ref.read(todayPrayerTimesProvider);
    asyncTimes.whenData((times) async {
      await AlarmService.instance.scheduleTodayAdhansIfNeeded(times);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final themeController = ref.read(themeModeProvider.notifier);
    final l10n = AppLocalizations.of(context);

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
                      l10n.settings,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Boşluk - simetri için
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _StyledSettingsSection(
                      title: l10n.appearance,
                      children: [
                        _StyledSettingsItem(
                          icon: Icons.brightness_6_outlined,
                          title: l10n.theme,
                          subtitle: () {
                            switch (themeMode) {
                              case ThemeMode.system:
                                return l10n.useSystemTheme;
                              case ThemeMode.light:
                                return l10n.lightTheme;
                              case ThemeMode.dark:
                                return l10n.darkTheme;
                            }
                          }(),
                          onTap: () async {
                            final selected = await showDialog<ThemeMode>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(l10n.appearance),
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    ThemeMode selectedMode = themeMode;
                                    return RadioGroup<ThemeMode>(
                                      groupValue: selectedMode,
                                      onChanged: (v) {
                                        setState(() => selectedMode = v!);
                                        Navigator.pop(context, v);
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: Text(l10n.useSystemTheme),
                                            subtitle: Text(
                                              l10n.followPhoneTheme,
                                            ),
                                            leading: Radio<ThemeMode>(
                                              value: ThemeMode.system,
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(l10n.lightTheme),
                                            leading: Radio<ThemeMode>(
                                              value: ThemeMode.light,
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(l10n.darkTheme),
                                            leading: Radio<ThemeMode>(
                                              value: ThemeMode.dark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                            if (selected != null) {
                              themeController.setThemeMode(selected);
                            }
                          },
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.format_size,
                                    color: Color(0xFF14B866),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      l10n.fontSize,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    () {
                                      // Use the current provider value for the label to reflect the active setting
                                      // or use a local state if we want the label to update while dragging.
                                      // Let's stick to provider for now, or better, read the slider value if we had local state.
                                      // Since we are inside a StatefulBuilder (from the dialog previously? No, this is directly in build now).
                                      // We need a local state to update the slider UI while dragging without rebuilding the whole app.
                                      // So we should wrap this part in a StatefulBuilder or hook.
                                      final scale = ref.watch(fontSizeProvider);
                                      if (scale == 0.85) {
                                        return l10n.fontSizeSmall;
                                      }
                                      if (scale == 1.0) {
                                        return l10n.fontSizeMedium;
                                      }
                                      if (scale == 1.15) {
                                        return l10n.fontSizeLarge;
                                      }
                                      if (scale == 1.3) {
                                        return l10n.fontSizeExtraLarge;
                                      }
                                      return l10n.fontSizeMedium;
                                    }(),
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _FontSizeSlider(ref: ref),
                            ],
                          ),
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        _StyledSettingsItem(
                          icon: Icons.animation,
                          title: l10n.animations,
                          subtitle: l10n.showAnimations,
                          isSwitch: true,
                          switchValue: ref.watch(animationsEnabledProvider),
                          onSwitchChanged: (v) {
                            ref
                                .read(animationsEnabledProvider.notifier)
                                .setEnabled(v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StyledSettingsSection(
                      title: l10n.notifications,
                      children: [
                        _StyledSettingsItem(
                          icon: Icons.notifications_active_outlined,
                          title: l10n.prayerNotifications,
                          subtitle: l10n.adhanNotificationsDesc,
                          isSwitch: true,
                          switchValue: _prayerNotifications,
                          onSwitchChanged: _togglePrayerNotifications,
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        _StyledSettingsItem(
                          icon: Icons.notification_important_outlined,
                          title: l10n.prayerBarInNotification,
                          subtitle: l10n.locale.languageCode == 'tr'
                              ? 'Bildirim çubuğunda namaz vakitlerini göster'
                              : 'Show prayer times in notification bar',
                          isSwitch: true,
                          switchValue: _prayerBarEnabled,
                          onSwitchChanged: _togglePrayerBar,
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),

                        _StyledSettingsItem(
                          icon: Icons.refresh,
                          title: l10n.reset,
                          subtitle: l10n.locale.languageCode == 'tr'
                              ? 'Bildirim ve ezan ayarlarını varsayılan değerlerine sıfırla'
                              : 'Reset notification and adhan settings to default values',
                          onTap: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(l10n.reset),
                                content: Text(
                                  l10n.locale.languageCode == 'tr'
                                      ? 'Bildirim ve ezan ayarlarını varsayılan değerlerine sıfırlamak istediğinizden emin misiniz?'
                                      : 'Are you sure you want to reset notification and adhan settings to default values?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(l10n.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(
                                      l10n.reset,
                                      style: const TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              await _resetNotificationSettings();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.locale.languageCode == 'tr'
                                          ? 'Bildirim ve ezan ayarları sıfırlandı.'
                                          : 'Notification and adhan settings reset.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StyledSettingsSection(
                      title: l10n.locationAndQibla,
                      children: [
                        _StyledSettingsItem(
                          icon: Icons.location_on,
                          title: l10n.locationSettings,
                          subtitle: l10n.currentCity,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MoreLocationPage(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        _StyledSettingsItem(
                          icon: Icons.explore,
                          title: l10n.qiblaCalibration,
                          subtitle: l10n.calibrateAndTest,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QiblaCalibrationPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StyledSettingsSection(
                      title: l10n.other,
                      children: [
                        _StyledSettingsItem(
                          icon: Icons.language,
                          title: l10n.language,
                          subtitle:
                              ref.watch(localeProvider).languageCode == 'tr'
                              ? l10n.turkish
                              : l10n.english,
                          onTap: () async {
                            final result = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(l10n.languageSelection),
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    String selectedLang = ref
                                        .read(localeProvider)
                                        .languageCode;
                                    return RadioGroup<String>(
                                      groupValue: selectedLang,
                                      onChanged: (v) {
                                        setState(() => selectedLang = v!);
                                        Navigator.pop(context, v);
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text('🇹🇷 Türkçe'),
                                            leading: Radio<String>(value: 'tr'),
                                          ),
                                          ListTile(
                                            title: const Text('🇬🇧 English'),
                                            leading: Radio<String>(value: 'en'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                            if (result != null) {
                              final locale = result == 'en'
                                  ? const Locale('en', 'US')
                                  : const Locale('tr', 'TR');
                              await ref
                                  .read(localeProvider.notifier)
                                  .setLocale(locale);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.languageChanged),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        _StyledSettingsItem(
                          icon: Icons.lock,
                          title: l10n.privacyAndPermissions,
                          subtitle: l10n.privacyPermissionsDesc,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PrivacyPermissionsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StyledSettingsSection(
                      title: l10n.about,
                      children: [
                        _StyledSettingsItem(
                          icon: Icons.apps,
                          title: l10n.appVersion,
                          subtitle: 'v$_appVersion ($_buildNumber)',
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        _StyledSettingsItem(
                          icon: Icons.code,
                          title: l10n.developer,
                          subtitle: l10n.appName,
                        ),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        _StyledSettingsItem(
                          icon: Icons.info_outline,
                          title: l10n.about,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AboutPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyledSettingsSection extends StatelessWidget {
  const _StyledSettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Card(
          elevation: 4,
          shadowColor: Colors.black26,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _StyledSettingsItem extends StatelessWidget {
  const _StyledSettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white70 : Colors.black54;

    Widget currentTrailing = const SizedBox.shrink();
    if (isSwitch) {
      currentTrailing = Switch.adaptive(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeThumbColor: const Color(0xFF14B866),
        activeTrackColor: const Color(0xFF14B866).withValues(alpha: 0.5),
      );
    } else if (onTap != null) {
      currentTrailing = Icon(Icons.chevron_right, color: subColor);
    }

    return InkWell(
      onTap: isSwitch ? () => onSwitchChanged?.call(!switchValue) : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF14B866)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, color: textColor)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 12, color: subColor),
                    ),
                  ],
                ],
              ),
            ),
            currentTrailing,
          ],
        ),
      ),
    );
  }
}

class _FontSizeSlider extends StatefulWidget {
  const _FontSizeSlider({required this.ref});

  final WidgetRef ref;

  @override
  State<_FontSizeSlider> createState() => _FontSizeSliderState();
}

class _FontSizeSliderState extends State<_FontSizeSlider> {
  double? _localValue;

  @override
  Widget build(BuildContext context) {
    final currentValue = _localValue ?? widget.ref.watch(fontSizeProvider);

    return Slider(
      value: currentValue ?? 1.0,
      min: 0.85,
      max: 1.3,
      divisions: 3,
      activeColor: const Color(0xFF14B866),
      inactiveColor: const Color(0xFF14B866).withValues(alpha: 0.3),
      onChanged: (value) {
        setState(() {
          _localValue = value;
        });
      },
      onChangeEnd: (value) {
        widget.ref.read(fontSizeProvider.notifier).setFontSize(value);
        setState(() {
          _localValue = null;
        });
      },
    );
  }
}
