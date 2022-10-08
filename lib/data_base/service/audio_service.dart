import 'dart:async';

import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();
  final StreamController streamController = StreamController.broadcast();

  Stream<PlayerState> stateStream() {
    return player.playerStateStream;
  }

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

  Future seek(Duration duration) async {
    try {
      await player.seek(duration);
    } catch (e) {
      print("@#@#@");
      print(e);
    }
  }

  Future dispose() {
    return player.dispose();
  }
}
