import 'package:audioplayers/audioplayers.dart';

class BibleAudioPlayer {
  BibleAudioPlayer({
    this.url,
    this.totalDuration,
    this.currentDuration,
  }) {
    _init();
  }

  final Function(Duration durtaion) totalDuration;

  final Function(Duration durtaion) currentDuration;

  final String url;

  AudioPlayer _audioPlayer = AudioPlayer();

  String dateTimeFrom(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
    //   return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _init() async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.onDurationChanged.listen((_current) {
      this.totalDuration(_current);
    });
    _audioPlayer.onAudioPositionChanged.listen((_total) {
      this.currentDuration(_total);
    });
  }

  Future play({String url}) async {
    await _audioPlayer.play(url ?? this.url);
  }

  Future pause() async {
    await _audioPlayer.pause();
  }

  Future stop() async {
    await _audioPlayer.stop();
  }

  Future dispose() async {
    await _audioPlayer.dispose();
  }

  Future seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
}
