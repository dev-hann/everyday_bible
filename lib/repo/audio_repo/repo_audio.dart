import 'dart:async';

import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:just_audio/just_audio.dart';

part 'audio_impl.dart';

/// Repository controlling audio playback of Quiet Time audio sources.
abstract class AudioRepo extends Repo {
  /// Broadcast stream emitting the latest [AudioState] on every change.
  Stream<AudioState> stateStream();

  /// Sets the player's [loopMode].
  Future<void> setLoopMode(LoopMode loopMode);

  /// Sets the playback volume to [value] (0.0 to 1.0).
  Future<void> setVolume(double value);

  /// Loads the audio at [audioURL] and starts tracking its playback state.
  Future<void> loadAudio(String audioURL);

  /// Starts or resumes playback.
  Future<void> playAudio();

  /// Pauses playback.
  Future<void> pauseAudio();

  /// Moves the playhead to [duration].
  Future<void> seekAudio(Duration duration);

  /// Stops playback and releases the current source.
  Future<void> stopAudio();
}
