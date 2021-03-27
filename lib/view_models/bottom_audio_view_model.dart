import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class BottomAudioViewModel extends ChangeNotifier{
  BottomAudioViewModel(this.audioAsset);

  final String audioAsset;

  String get audioDurationText {
    try {
      return "${_dateTimeFrom(_audioCurrentDuration)} / ${_dateTimeFrom(_audioTotalDuration)}";
    } catch (e) {
      return "00:00 / 00:00";
    }
  }

  String _dateTimeFrom(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription _audioCurrentSub;

  StreamSubscription _audioTotalSub;

  Duration _audioTotalDuration;

  Duration _audioCurrentDuration;

  void initAudio() async {
    ///add check logic
    int res = await _audioPlayer.setUrl(audioAsset);
    _audioTotalSub = _audioPlayer.onDurationChanged.listen((event) {
      _audioTotalDuration = event;
      notifyListeners();
    });
    _audioCurrentSub = _audioPlayer.onAudioPositionChanged.listen((event) {
      _audioCurrentDuration = event;
      notifyListeners();
    });

  }

  void _disposeAudio() {
    _audioCurrentSub.cancel();
    _audioTotalSub.cancel();
  }

  void playAudio() {
    _audioPlayer.play(audioAsset);
  }


  void pauseAudio() {
    _audioPlayer.pause();
  }

  void dispose(){
    super.dispose();
    _disposeAudio();
  }
}