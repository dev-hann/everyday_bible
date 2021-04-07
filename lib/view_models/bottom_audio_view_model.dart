part of view_model;

class BottomAudioViewModel extends BibleViewModel {
  BottomAudioViewModel(this.audioAsset);

  late final String audioAsset;

  String get currentDurationText => _dateTimeFrom(_audioCurrentDuration);

  String get totalDurationText => _dateTimeFrom(_audioTotalDuration);

  String get audioDurationText => "$currentDurationText / $totalDurationText";


  ///[todo] RF
  String _dateTimeFrom(Duration? duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes;
    String twoDigitSeconds;
    try {
      twoDigitMinutes = twoDigits(duration!.inMinutes.remainder(60));
      twoDigitSeconds = twoDigits(duration!.inSeconds.remainder(60));
    } catch (e) {
      print(e);
      return "00:00";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }


  ///[todo] make to extension
  AudioPlayer _audioPlayer = AudioPlayer();

  late StreamSubscription _audioCurrentSub;

  late StreamSubscription _audioTotalSub;

  late StreamSubscription _audioStateSub;

   Duration? _audioTotalDuration;

  double get totalSliderValue =>
      _audioTotalDuration?.inMilliseconds?.toDouble() ?? 1.0;

   Duration? _audioCurrentDuration;

  double get currentSliderValue =>
      _audioCurrentDuration?.inMilliseconds?.toDouble() ?? 0.0;

  bool _sliderIsOnTapping=false;

  void sliderOnChangeStart(_){
    _sliderIsOnTapping=true;
  }
  void sliderOnChangeEnd(double value){
    _sliderIsOnTapping=false;
    _seekAudio(Duration(milliseconds: value.toInt()));
  }
  void sliderOnChanged(double value) {
    _audioCurrentDuration = Duration(milliseconds: value.toInt());
    notifyListeners();
  }

  late AnimationController playButtonAnimation;

  void _playButtonPlayIcon() {
    playButtonAnimation.reverse();
  }

  void _playButtonPauseIcon() {
    playButtonAnimation.forward();
  }

  bool get isPlaying => playButtonAnimation.value == 1;

  ///[todo] RF
  bool _miniMode=true;

  bool get isMiniMode=>_miniMode;

  void setMiniMode(){
    _miniMode=true;
    notifyListeners();
  }

  void setMoreMode(){
    _miniMode = false;
    notifyListeners();
  }

  void _loadAnimationController(TickerProvider vsync) {
    Duration _duration = Duration(milliseconds: 300);
    playButtonAnimation = AnimationController(vsync: vsync, duration: _duration)
      ..addListener(() {
        notifyListeners();
      });
  }

  void initBottomPlayer({required TickerProvider vsync}) async {

    _loadAnimationController(vsync);

    int res = await _audioPlayer.setUrl(audioAsset);
    print(res);
    _audioTotalSub = _audioPlayer.onDurationChanged.listen((event) {
      _audioTotalDuration = event;
      notifyListeners();
    });
    _audioCurrentSub = _audioPlayer.onAudioPositionChanged.listen((event) {
      if(!_sliderIsOnTapping) {
        _audioCurrentDuration = event;
        notifyListeners();
      }
    });
    _audioStateSub = _audioPlayer.onPlayerStateChanged.listen((event) {
      if(event==AudioPlayerState.COMPLETED){
        _pauseAudio();
        _playButtonPauseIcon();
        _audioCurrentDuration = Duration.zero;
        notifyListeners();
      }
    });
  }

  void _disposeAudio() {
    _audioCurrentSub.cancel();
    _audioTotalSub.cancel();
    _audioStateSub.cancel();
  }

  void onTapPlayButton() {
    if (isPlaying) {
      _pauseAudio();
      _playButtonPlayIcon();
    } else {
      _playAudio();
      _playButtonPauseIcon();
    }
  }

  void onTapMoreButton() {
    if (isMiniMode) {
      setMoreMode();
    }else{
      setMiniMode();
    }
  }

  void onTapAudioForward(){
    _seekAudio(_audioCurrentDuration!+Duration(seconds: 5));
  }

  void onTapAudioRewind(){
    _seekAudio(_audioCurrentDuration!-Duration(seconds: 5));

  }
  Future _playAudio() async {
    int res = await _audioPlayer.play(audioAsset);
  }

  Future _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future _seekAudio(Duration position)async{
    _audioPlayer.seek(position);
  }

  void dispose() {
    super.dispose();
    _disposeAudio();
  }

  double get playerHeight=> isMiniMode?kToolbarHeight:kToolbarHeight*4.5;

}
