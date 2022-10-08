import 'package:equatable/equatable.dart';

class QuiteTimeAudio extends Equatable {
  const QuiteTimeAudio({
    this.title = "",
    this.isPlaying = false,
    this.url = "",
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });
  final bool isPlaying;
  final String title;
  final String url;
  final Duration position;
  final Duration duration;

  @override
  List<Object?> get props => [
        title,
        isPlaying,
        position,
        duration,
        url,
      ];

  QuiteTimeAudio copyWith({
    bool? isPlaying,
    String? title,
    String? url,
    Duration? position,
    Duration? duration,
  }) {
    return QuiteTimeAudio(
      isPlaying: isPlaying ?? this.isPlaying,
      title: title ?? this.title,
      url: url ?? this.url,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}
