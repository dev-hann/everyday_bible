part of view_model;

enum AudioState {
  Loading,
  Ready,
  Playing,
  Pause,
}

///[TODO] while [initBottomPlayer] ,if change asset(change Bible Date), can be happened Error!

class BottomAudioViewModel extends BibleViewModel {
  BottomAudioViewModel({
    required this.bibleDatabase,
  });

  final BibleDatabase bibleDatabase;

  EverydayBible? get _selectedBible => bibleDatabase.selectedDateBible;

  String get title => _selectedBible!.title;

  String get subtitle => _selectedBible!.subTitle;

  String get audioURL => _selectedBible!.audioURL;

  Uint8List? get audioByteData => _selectedBible!.audioByteData;

  String get currentDurationText => _dateTimeFrom(_audioCurrentDuration);

  String get totalDurationText => _dateTimeFrom(audioTotalDuration);

  String get audioDurationText => "$currentDurationText / $totalDurationText";

  ///[todo] RF
  String _dateTimeFrom(Duration? duration) {
    if (duration == null) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes;
    String twoDigitSeconds;
    twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  StreamSubscription? _audioCurrentSub;

  StreamSubscription? _audioTotalSub;

  StreamSubscription? _audioStateSub;

  Duration? audioTotalDuration;

  double get totalSliderValue {
    if (audioTotalDuration == null) return 1.0;
    return audioTotalDuration!.inMilliseconds.toDouble();
  }

  Duration? _audioCurrentDuration;

  double get currentSliderValue {
    if (_audioCurrentDuration == null) return 0.0;
    return _audioCurrentDuration!.inMilliseconds.toDouble();
  }

  bool _sliderIsOnTapping = false;

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

  AnimationController? playButtonAnimation;

  void _playButtonPlayIcon() {
    playButtonAnimation!.reverse();
  }

  void _playButtonPauseIcon() {
    playButtonAnimation!.forward();
  }

  bool get isPlaying => _audioState == AudioState.Playing;

  bool get isLoading => _audioState == AudioState.Loading;

  AudioState _audioState = AudioState.Loading;

  set audioState(AudioState _state) {
    if (_audioState == _state) return;
    _audioState = _state;
    notifyListeners();
  }

  void _stateUpdate(AudioState _state) {
    audioState = _state;
  }

  ///[todo] RF
  bool _miniMode = true;

  bool get isMiniMode => _miniMode;

  void setMiniMode() {
    _miniMode = true;
    notifyListeners();
  }

  void setMoreMode() {
    _miniMode = false;
    notifyListeners();
  }

  void _loadAnimationController(TickerProvider vsync) {
    if (playButtonAnimation == null) {
      Duration _duration = Duration(milliseconds: 300);
      playButtonAnimation =
          AnimationController(vsync: vsync, duration: _duration)
            ..addListener(() {
              notifyListeners();
            });
    }
  }

  void initBottomPlayer({required TickerProvider vsync}) async {
    _stateUpdate(AudioState.Loading);
    _disposeAudio();
    _loadAnimationController(vsync);

    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntryPoint,
    );

    if (audioByteData == null) {
      final _res = (await http.get(Uri.parse(audioURL))).bodyBytes;
      EverydayBible? _tmpBible = _selectedBible;
      _tmpBible?.setAudioByteData(_res);
      await bibleDatabase.updateBible(_tmpBible!);
    }
    await AudioService.customAction('set',
        {"assetByteData": audioByteData, "title": title, "subtitle": subtitle});

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

  void _disposeAudio() {
    _audioStateSub?.cancel();
    _audioCurrentSub?.cancel();
    _audioTotalSub?.cancel();
  }

  void onTapPlayButton() {
    if (isPlaying) {
      AudioService.pause();
    } else {
      AudioService.play();
    }
  }

  void onTapMoreButton() {
    if (isMiniMode) {
      setMoreMode();
    } else {
      setMiniMode();
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

  void dispose() {
    super.dispose();
    _disposeAudio();
  }

  double get playerHeight => isMiniMode ? kToolbarHeight : kToolbarHeight * 4.5;
}

/// this functions must be top-level
void _audioPlayerTaskEntryPoint() async {
  AudioServiceBackground.run(() => _AudioPlayerTask());
}

class _AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioProcessingState? _skipState;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    return super.onStart(params);
  }

  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }

  @override
  Future onCustomAction(String name, arguments) async {
    switch (name) {
      case 'set':
        final Uint8List assetByteData = arguments!['assetByteData'];
        final String title = arguments['title'];
        final String subtitle = arguments['subtitle'];

          await _audioPlayer.setAudioSource(
              _AudioByteDataSource(assetByteData));

        print("AudioPlayer : Asset Load Completed!");

        final MediaItem _mediaItem = MediaItem(
          id: title,
          album: subtitle,
          title: title,
          duration: _audioPlayer.duration,
        );
        await AudioServiceBackground.setMediaItem(_mediaItem);

        _audioPlayer.playerStateStream.listen((playerState) {
          AudioServiceBackground.setState(
            playing: playerState.playing,
            processingState: _getProcessingState(),
            position: _audioPlayer.position,
            bufferedPosition: _audioPlayer.bufferedPosition,
            speed: _audioPlayer.speed,
            controls: [
              MediaControl.skipToPrevious,
              playerState.playing ? MediaControl.pause : MediaControl.play,
              MediaControl.skipToNext,
            ],
          );
        });

        _audioPlayer.processingStateStream.listen((state) {
          switch (state) {
            case ProcessingState.completed:
              // In this example, the service stops when reaching the end.
              onStop();
              break;
            case ProcessingState.ready:
              // If we just came from skipping between tracks, clear the skip
              // state now that we're ready to play.
              _skipState = null;
              break;
            default:
              break;
          }
        });
    }

    return super.onCustomAction(name, arguments);
  }

  @override
  Future<void> onPlay() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> onPause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }
}

class _AudioByteDataSource extends StreamAudioSource {
  _AudioByteDataSource(this.audioByteData) : super("tag");

  final Uint8List audioByteData;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start = start ?? 0;
    end = end ?? audioByteData.length;
    return StreamAudioResponse(
      sourceLength: audioByteData.length,
      contentLength: audioByteData.length,
      offset: 0,
      contentType: 'audio/mp3',
      stream: Stream.value(List<int>.from(audioByteData.skip(start).take(end - start))),
    );
  }
}
