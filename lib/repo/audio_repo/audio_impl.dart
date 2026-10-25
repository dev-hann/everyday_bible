part of 'repo_audio.dart';

/// [AudioRepo] implementation delegating playback to just_audio.
class AudioImpl extends AudioRepo {
  /// The just_audio player performing the actual playback.
  final AudioPlayer player = AudioPlayer();

  /// Latest snapshot of the playback state.
  AudioState state = const AudioState();

  /// Applies [callback] to [state] and broadcasts the new state.
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
  Future<void> loadAudio(String audioURL) async {
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
            unawaited(player.pause());
          case LoopMode.all:
          case LoopMode.one:
            unawaited(
              player.pause().then((value) {
                unawaited(player.seek(Duration.zero));
              }),
            );
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
  Future<void> pauseAudio() async {
    await player.pause();
    updateState((newState) => newState.copyWith(playing: false));
  }

  @override
  Future<void> playAudio() async {
    await player.play();
    updateState((newState) => newState.copyWith(playing: true));
  }

  @override
  Future<void> seekAudio(Duration duration) {
    return player.seek(duration);
  }

  @override
  Future<void> setLoopMode(LoopMode loopMode) async {
    await player.setLoopMode(loopMode);
    updateState((newState) => newState.copyWith(loopMode: loopMode));
  }

  @override
  Future<void> setVolume(double value) {
    return player.setVolume(value);
  }

  @override
  Future<void> stopAudio() {
    return player.stop();
  }
}
