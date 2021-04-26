import 'dart:async';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:everydaybible/utils/qt_utils/qt_audio_player.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:everydaybible/controllers/qt_controller.dart';
import 'package:flutter/material.dart';

enum AudioType {
  Mini,
  Expanded,
}

enum AudioState {
  Loading,
  Ready,
  Playing,
  Pause,
}


class QTAudioViewModel extends ChangeNotifier {
  QTAudioViewModel(this.controller);

  final QTController controller;

  AudioType type = AudioType.Mini;

  bool get isMiniMode => type == AudioType.Mini;

  bool get isExpandedMode => !isMiniMode;

  late final AnimationController playButtonController;

  late final AnimationController expandedButtonController;

  AnimationController _animationController(TickerProvider vsync) =>
      AnimationController(vsync: vsync, duration: Duration(milliseconds: 300));

  void initAnimation(TickerProvider vsync) {
    playButtonController = _animationController(vsync);
    expandedButtonController = _animationController(vsync);
  }

  @override
  void addListener(listener) {
    playButtonController.addListener(listener);
    expandedButtonController.addListener(listener);
    controller.addListener(initAudio);
    super.addListener(listener);
  }

  @override
  void dispose() {
    playButtonController.dispose();
    expandedButtonController.dispose();
    controller.removeListener(initAudio);
    _disposeAudio();
    super.dispose();
  }

  void _disposeAudio() {
    _audioStateSub?.cancel();
    _audioCurrentSub?.cancel();
    _audioTotalSub?.cancel();
  }


/// [todo] can delete type argument
  void _toggleMode() {
    if (type == AudioType.Mini) {
      type = AudioType.Expanded;
    } else {
      type = AudioType.Mini;
    }
  }

  AudioState _audioState = AudioState.Loading;

  bool get isLoading =>_audioState==AudioState.Loading;
  bool get isPlaying => _audioState == AudioState.Playing;

  void _stateUpdate(AudioState _state) {
    if (_audioState == _state) return;
    _audioState = _state;
    notifyListeners();
  }


  StreamSubscription? _audioCurrentSub;

  StreamSubscription? _audioTotalSub;

  StreamSubscription? _audioStateSub;

  Uint8List? get _audioByteData => controller.selectedQT!.audioByteData;

  String get _audioURL => controller.selectedQT!.audioURL;

  String get _audioTitle => controller.selectedQT!.title;

  String get _audioSubtitle => controller.selectedQT!.subTitle;

  /// how can i manage interrupt
  void initAudio() async {
    _stateUpdate(AudioState.Loading);
    _disposeAudio();

    await AudioService.start(
      backgroundTaskEntrypoint: audioPlayerTaskEntryPoint,
    );

    if (_audioByteData != null) {
     await AudioService.customAction(
          "setByteData", {'assetByteData': _audioByteData});
    } else {
      await AudioService.customAction("setURL", {'url': _audioURL});
    }
    print("AudioPlayer : Asset Load Completed!");

    await AudioService.customAction(
        "ready", {'title': _audioTitle, 'subtitle': _audioSubtitle});

    _audioCurrentSub = AudioService.positionStream.listen((event) {
      if (!_sliderIsOnTapping) {
        _audioCurrentDuration = event;
      }
      notifyListeners();
    });

    _audioTotalSub = AudioService.currentMediaItemStream.listen((event) {
      if (audioTotalDuration != event?.duration) {
        audioTotalDuration = event?.duration;
        notifyListeners();
      }
    });


    _stateUpdate(AudioState.Ready);

    _audioStateSub = AudioService.playbackStateStream.listen(_stateListener);


  }
  void _stateListener(PlaybackState _state) {
    if (_state.playing) {
      _stateUpdate(AudioState.Playing);
      _playButtonPauseIcon();
    } else {
      _stateUpdate(AudioState.Pause);
      _playButtonPlayIcon();
    }
  }

  void _playButtonPlayIcon() {
    playButtonController.reverse();
  }

  void _playButtonPauseIcon() {
    playButtonController.forward();
  }

  void onTapPlayButton(){
    if (isPlaying) {
      AudioService.pause();
    } else {
      AudioService.play();
    }
  }

  void onTapExpandedButton() {
    _toggleMode();
    if (isMiniMode) {
      expandedButtonController.reverse();
    } else {
      expandedButtonController.forward();
    }
  }

  void onTapAudioForward() {
    _seekAudio(_audioCurrentDuration! + Duration(seconds: 5));
  }

  void onTapAudioRewind() {
    _seekAudio(_audioCurrentDuration! - Duration(seconds: 5));
  }

  Future _seekAudio(Duration position) async {
    AudioService.seekTo(position);
  }



  /// Duration
  String get currentDurationText => _dateTimeFrom(_audioCurrentDuration);

  String get totalDurationText => _dateTimeFrom(audioTotalDuration);

  String _dateTimeFrom(Duration? duration) {
    if (duration == null) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes;
    String twoDigitSeconds;
    twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Duration? audioTotalDuration;

  Duration? _audioCurrentDuration;




  /// slider
  bool _sliderIsOnTapping = false;

  double get totalSliderValue {
    if (audioTotalDuration == null) return 1.0;
    return audioTotalDuration!.inMilliseconds.toDouble();
  }

  double get currentSliderValue {
    if (_audioCurrentDuration == null) return 0.0;
    return _audioCurrentDuration!.inMilliseconds.toDouble();
  }

  void sliderOnChangeStart(_) {
    _sliderIsOnTapping = true;
  }

  void sliderOnChangeEnd(double value) {
    _sliderIsOnTapping = false;
    _seekAudio(Duration(milliseconds: value.toInt()));
  }

  void sliderOnChanged(double value) {
    _audioCurrentDuration = Duration(milliseconds: value.toInt());
    notifyListeners();
  }

}
