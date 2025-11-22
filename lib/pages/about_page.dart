import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
                          Text(
                            'Geliştirici menüsü',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bu bölüm, ezan sesini ve ezan bildirim planlamasını test etmek için kullanılır.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _toggleAdhanPlayback,
                            icon: Icon(
                              _isAdhanPlaying ? Icons.stop : Icons.play_arrow,
                            ),
                            label: Text(
                              _isAdhanPlaying
                                  ? 'Ezan sesini durdur'
                                  : 'Ezan sesini çal (hemen)',
                            ),
                          ),
                          const SizedBox(height: 8),
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
}
