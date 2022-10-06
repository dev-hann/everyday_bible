import 'dart:async';

import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();
  final StreamController streamController = StreamController.broadcast();
  Stream<Duration?> durationStream() {
    return player.durationStream;
  }

  Stream<Duration> positionStream() {
    return player.positionStream;
  }

  Future loadAudio(String audioURL) async {
    await player.setUrl(audioURL, preload: false);
  }

  Future pause() {
    return player.pause();
  }

  Future play() {
    return player.play();
  }

  Future seek(Duration duration) {
    return player.seek(duration);
  }

  Future dispose() {
    return player.dispose();
  }
}
