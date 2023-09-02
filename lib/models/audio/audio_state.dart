import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

class AudioState extends Equatable {
  const AudioState({
    this.url = "",
    this.playing = false,
    this.state = ProcessingState.loading,
    this.loopMode = LoopMode.all,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.volume = 0.0,
  });
  final String url;
  final bool playing;
  final ProcessingState state;
  final LoopMode loopMode;
  final Duration duration;
  final Duration position;
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
