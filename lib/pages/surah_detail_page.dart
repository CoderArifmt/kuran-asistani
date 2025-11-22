import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../core/models/ayah.dart';
import '../features/audio_player/quran_audio_player.dart';
import '../l10n/app_localizations.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahNameTr,
    required this.surahNameAr,
  });

  final int surahNumber;
  final String surahNameTr;
  final String surahNameAr;

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage> {
  late final QuranAudioPlayer _audioPlayer;
  int? _currentAyahIndex;
  bool _isLoadingAudio = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = QuranAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  Future<void> _onAyahAudioPressed(Ayah ayah, int index) async {
    final url = ayah.audioUrl;
    if (url == null) return;

    // Aynı ayete tekrar basılırsa durdur
    if (_currentAyahIndex == index && _audioPlayer.playing) {
      await _audioPlayer.stop();
      setState(() {});
      return;
    }

    setState(() {
      _currentAyahIndex = index;
      _isLoadingAudio = true;
    });

    try {
      await _audioPlayer.playFromUrl(url);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetail = ref.watch(surahDetailProvider(widget.surahNumber));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surahNameTr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.surahNameAr, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('${AppLocalizations.of(context).errorLoadingSurah} $e'),
          ),
        ),
        data: (detail) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: detail.ayahs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ayah = detail.ayahs[index];
              final isCurrent = _currentAyahIndex == index;
              final canPlay = ayah.audioUrl != null;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF111827).withValues(alpha: 0.7)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).ayahNumber(ayah.numberInSurah),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        if (canPlay)
                          IconButton(
                            onPressed: () => _onAyahAudioPressed(ayah, index),
                            icon: _isLoadingAudio && isCurrent
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    isCurrent && _audioPlayer.playing
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                  ),
                            color: const Color(0xFF14B866),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        ayah.text,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 20, height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ayah.translationText ?? '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark
                            ? const Color(0xFFE5E7EB)
                            : const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
