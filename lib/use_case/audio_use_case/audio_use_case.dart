import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/use_case/use_case.dart';
import 'package:just_audio/just_audio.dart';

/// Use case controlling audio playback through [AudioRepo].
class AudioUseCase extends UseCase<AudioRepo> {
  /// Creates an audio use case backed by [repo].
  AudioUseCase(super.repo);

  /// Broadcast stream emitting the latest [AudioState] on every change.
  Stream<AudioState> stateStream() {
    return repo.stateStream();
  }

  /// Sets the loop [mode] of the player.
  Future<void> setLoopMode(LoopMode mode) {
    return repo.setLoopMode(mode);
  }

  /// Loads the audio at [audioURL] for playback.
  Future<void> loadAudio(String audioURL) {
    return repo.loadAudio(audioURL);
  }

  /// Starts or resumes playback.
  Future<void> playAudio() {
    return repo.playAudio();
  }

  /// Pauses playback.
  Future<void> pauseAudio() {
    return repo.pauseAudio();
  }

  /// Moves the playhead to [duration].
  Future<void> seekAudio(Duration duration) {
    return repo.seekAudio(duration);
  }

  /// Sets the playback volume to [value] (0.0 to 1.0).
  Future<void> setVolume(double value) {
    return repo.setVolume(value);
  }

  /// Stops playback and releases the current source.
  Future<void> stopAudio() {
    return repo.stopAudio();
  }
}
