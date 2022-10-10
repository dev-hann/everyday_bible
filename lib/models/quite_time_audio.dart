import 'package:equatable/equatable.dart';
import 'package:everydaybible/enum/audio_state.dart';

class QuiteTimeAudio extends Equatable {
  const QuiteTimeAudio({
    this.state = AudioState.idle,
    this.isPlaying = false,
    this.title = "",
    this.url = "",
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 0.0,
  });
  final AudioState state;
  final bool isPlaying;
  final String title;
  final String url;
  final Duration position;
  final Duration duration;
  final double volume;
  @override
  List<Object?> get props => [
        title,
        state,
        isPlaying,
        position,
        duration,
        url,
        volume,
      ];

  QuiteTimeAudio copyWith({
    AudioState? state,
    bool? isPlaying,
    String? title,
    String? url,
    Duration? position,
    Duration? duration,
    double? volume,
  }) {
    return QuiteTimeAudio(
      state: state ?? this.state,
      isPlaying: isPlaying ?? this.isPlaying,
      title: title ?? this.title,
      url: url ?? this.url,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
    );
  }
}
