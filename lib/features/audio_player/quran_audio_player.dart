import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioPlayer {
  QuranAudioPlayer._internal();

  static final QuranAudioPlayer _instance = QuranAudioPlayer._internal();

  factory QuranAudioPlayer() => _instance;

  final AudioPlayer _player = AudioPlayer();

  Future<void> playFromUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e, stackTrace) {
      // just_audio can throw PlatformException(abort/connection aborted) when
      // loading is interrupted or the underlying platform player errors.
      // These should not crash the whole app; log them instead.
      debugPrint('Error while playing Quran audio: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  bool get playing => _player.playing;
}
