import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/notification_service.dart';
import '../l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _devTapCount = 0;
  bool _devMenuVisible = false;
  final AudioPlayer _adhanPlayer = AudioPlayer();
  bool _isAdhanPlaying = false;

  void _onVersionTap() {
    if (_devMenuVisible) return;
    _devTapCount++;
    if (_devTapCount >= 5) {
      setState(() {
        _devMenuVisible = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geliştirici menüsü açıldı')),
      );
    }
  }

  @override
  void dispose() {
    // Sayfadan çıkarken player'ı da durdurup serbest bırakıyoruz.
    _adhanPlayer.stop();
    _adhanPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAdhanPlayback() async {
    try {
      // Halihazırda çalıyorsa önce durdur.
      if (_isAdhanPlaying) {
        await _adhanPlayer.stop();
        if (!mounted) return;
        setState(() {
          _isAdhanPlaying = false;
        });
        return;
      }

      // Azan sesini Flutter asset'inden çal.
      await _adhanPlayer.setAsset('assets/audio/azan.mp3');
      await _adhanPlayer.play();
      if (!mounted) return;
      setState(() {
        _isAdhanPlaying = true;
      });

      // Çalma bitince durumu sıfırla.
      _adhanPlayer.playerStateStream
          .firstWhere(
            (state) => state.processingState == ProcessingState.completed,
          )
          .then((_) {
            if (mounted) {
              setState(() {
                _isAdhanPlaying = false;
              });
            }
          });
    } catch (e) {
      // Eğer asset bulunamaz veya player hata verirse, sadece logla.
      debugPrint('Adhan play error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

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
                          'Hakkında',
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF14B866,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.mosque_outlined,
                                  size: 48,
                                  color: Color(0xFF14B866),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Namaz ve Kur\'an Asistanı',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _onVersionTap,
                                child: Text(
                                  'Sürüm 1.0.0',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF6B7280),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Uygulama hakkında',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Namaz vakitlerini, kıble yönünü ve Kur\'an surelerini tek bir yerden takip edebilmen için tasarlandı. Konumuna göre günlük namaz vakitlerini gösterir, ezan bildirimleriyle seni uyarır ve Kur\'an & dua içerikleri sunar.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gizlilik',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Konum verilerin sadece cihazında kullanılır; sunucuya gönderilmez veya saklanmaz. Namaz vakitleri için yalnızca koordinat bilgisiyle dış API\'lere istek yapılır.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: 24),

                        if (_devMenuVisible) ...[
                          const Divider(),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.developer_mode,
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      ).developerMenu,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).adhanSoundAndNotificationTests,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF6B7280),
                                      ),
                                ),
                                const SizedBox(height: 16),
                                _DevMenuButton(
                                  icon: _isAdhanPlaying
                                      ? Icons.stop_circle_outlined
                                      : Icons.play_circle_outlined,
                                  label: _isAdhanPlaying
                                      ? AppLocalizations.of(context).stopSound
                                      : AppLocalizations.of(context).testSound,
                                  color: _isAdhanPlaying
                                      ? Colors.red
                                      : Theme.of(context).primaryColor,
                                  onTap: _toggleAdhanPlayback,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).notificationTestInfo,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _PrayerTestChip(
                                      label: AppLocalizations.of(context).imsak,
                                      onTap: () => _testNotification(
                                        AppLocalizations.of(context).imsak,
                                      ),
                                    ),
                                    _PrayerTestChip(
                                      label: AppLocalizations.of(context).ogle,
                                      onTap: () => _testNotification(
                                        AppLocalizations.of(context).ogle,
                                      ),
                                    ),
                                    _PrayerTestChip(
                                      label: AppLocalizations.of(
                                        context,
                                      ).ikindi,
                                      onTap: () => _testNotification(
                                        AppLocalizations.of(context).ikindi,
                                      ),
                                    ),
                                    _PrayerTestChip(
                                      label: AppLocalizations.of(context).aksam,
                                      onTap: () => _testNotification(
                                        AppLocalizations.of(context).aksam,
                                      ),
                                    ),
                                    _PrayerTestChip(
                                      label: AppLocalizations.of(context).yatsi,
                                      onTap: () => _testNotification(
                                        AppLocalizations.of(context).yatsi,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _testNotification(String prayerName) async {
    // 5 saniye sonrasına planla
    await NotificationService.instance.scheduleTestNotification(
      prayerName: prayerName,
      delay: const Duration(seconds: 5),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$prayerName ${AppLocalizations.of(context).notificationScheduled}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _DevMenuButton extends StatelessWidget {
  const _DevMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrayerTestChip extends StatelessWidget {
  const _PrayerTestChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
      side: BorderSide(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.1),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
