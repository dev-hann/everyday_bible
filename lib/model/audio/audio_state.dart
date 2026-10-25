import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

/// Immutable snapshot of the audio player for QT audio playback.
class AudioState extends Equatable {
  /// Creates an audio state snapshot.
  const AudioState({
    this.url = '',
    this.playing = false,
    this.state = ProcessingState.loading,
    this.loopMode = LoopMode.all,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.volume = 0.0,
  });

  /// URL of the audio source currently loaded.
  final String url;

  /// Whether the player is currently playing.
  final bool playing;

  /// Processing state of the underlying player.
  final ProcessingState state;

  /// Loop mode applied during playback.
  final LoopMode loopMode;

  /// Total length of the loaded audio.
  final Duration duration;

  /// Current playback position.
  final Duration position;

  /// Playback volume, from 0.0 to 1.0.
  final double volume;

  @override
  List<Object?> get props => [
        url,
        playing,
        state,
        loopMode,
        duration,
        position,
        volume,
      ];

  /// Returns a copy of this state with the given fields replaced.
  AudioState copyWith({
    String? url,
    bool? playing,
    ProcessingState? state,
    LoopMode? loopMode,
    Duration? duration,
    Duration? position,
    double? volume,
  }) {
    return AudioState(
      url: url ?? this.url,
      playing: playing ?? this.playing,
      state: state ?? this.state,
      loopMode: loopMode ?? this.loopMode,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      volume: volume ?? this.volume,
    );
  }
}
