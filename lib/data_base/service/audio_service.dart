import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();

  Stream<Duration> durationStream() {
    return player.onDurationChanged;
  }

  Stream<Duration> positionStream() {
    return player.onPositionChanged;
  }

  Future loadAudio(String audioURL) {
    return player.setSourceUrl(audioURL);
  }

  Future pause() {
    return player.pause();
  }

  Future resume() {
    return player.resume();
  }

  Future seek(Duration duration) {
    return player.seek(duration);
  }
}
