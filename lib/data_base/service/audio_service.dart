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

  Future setLoopMode(int index) {
    return player.setLoopMode(LoopMode.values[index]);
  }

  Future loadAudio(String audioURL) async {
    await player.setUrl(audioURL, preload: false);
    await player.setLoopMode(LoopMode.off);
  }

  Future pause() {
    return player.pause();
  }

  Future play() {
    return player.play();
  }

  Future seek(Duration duration) async {
    await player.seek(duration);
  }

  Future dispose() {
    return player.dispose();
  }
}
