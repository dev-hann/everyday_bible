part of audio_repo;

class AudioImpl extends AudioRepo {
  final AudioPlayer player = AudioPlayer();
  AudioState state = const AudioState();
  void updateState(AudioState Function(AudioState newState) callback) {
    state = callback(state);
    _streamController.add(state);
  }

  final StreamController<AudioState> _streamController =
      StreamController.broadcast();

  @override
  Stream<AudioState> stateStream() {
    return _streamController.stream;
  }

  @override
  Future loadAudio(String audioURL) async {
    await player.dispose();
    await player.setUrl(audioURL);
    updateState(
      (newState) => newState.copyWith(url: audioURL),
    );
    player.durationStream.listen((event) {
      updateState((newState) => newState.copyWith(duration: event));
    });
    player.positionStream.listen((event) {
      updateState((newState) => newState.copyWith(position: event));
    });
    player.playingStream.listen((event) {
      updateState((newState) => newState.copyWith(playing: event));
    });
    player.playerStateStream.listen((event) {
      updateState(
          (newState) => newState.copyWith(state: event.processingState));
    });
    player.volumeStream.listen((event) {
      updateState((newState) => newState.copyWith(volume: event));
    });
  }

  @override
  Future pauseAudio() async {
    await player.pause();
    updateState((newState) => newState.copyWith(playing: false));
  }

  @override
  Future playAudio() async {
    await player.play();
    updateState((newState) => newState.copyWith(playing: true));
  }

  @override
  Future seekAudio(Duration duration) {
    return player.seek(duration);
  }

  @override
  Future setLoopMode(LoopMode loopMode) async {
    await player.setLoopMode(loopMode);
    updateState((newState) => newState.copyWith(loopMode: loopMode));
  }

  @override
  Future setVolume(double value) {
    return player.setVolume(value);
  }
}
