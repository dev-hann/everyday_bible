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
    // if (player.audioSource != null) {
    //   player.dispose();
    // }
    await player.setUrl(audioURL);
    updateState(
      (newState) => newState.copyWith(url: audioURL),
    );
    player.durationStream.listen((event) {
      updateState((newState) => newState.copyWith(duration: event));
    });
    player.positionStream.listen((event) {
      if (event == state.duration) {
        switch (player.loopMode) {
          case LoopMode.off:
            player.pause();
            break;
          case LoopMode.all:
          case LoopMode.one:
            player.pause().then((value) {
              player.seek(Duration.zero);
            });
            break;
        }
      }
      updateState(
        (newState) => newState.copyWith(position: event),
      );
    });
    player.playerStateStream.listen((event) {
      updateState(
        (newState) => newState.copyWith(
          playing: event.playing,
          state: event.processingState,
        ),
      );
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

  @override
  Future stopAudio() {
    return player.stop();
  }
}
