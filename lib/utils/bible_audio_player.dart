import 'package:audioplayers/audioplayers.dart';

class BibleAudioPlayer {
  AudioPlayer _audioPlayer = AudioPlayer();

  Stream<Duration> get totalDuration=> _audioPlayer.onDurationChanged;
  Stream<Duration> get currentDuration => _audioPlayer.onAudioPositionChanged;



  Future setURL(String url)async{
      await _audioPlayer.setUrl(url);
  }
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
