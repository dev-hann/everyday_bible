import 'package:audioplayers/audioplayers.dart';

class BibleAudioPlayer {
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<int> get totalDuration=> _audioPlayer.getDuration();
  Stream<Duration> get currentChanged => _audioPlayer.onAudioPositionChanged;
  Future play(String url) async {
     await _audioPlayer.play(url);
  }

  Future pause() async {
     await _audioPlayer.pause();
  }
  Future stop()async{
      await _audioPlayer.stop();
  }
  Future dispose() async {
   await _audioPlayer.dispose();
  }
}
