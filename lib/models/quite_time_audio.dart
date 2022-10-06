import 'package:equatable/equatable.dart';

class QuiteTimeAudio extends Equatable {
  const QuiteTimeAudio({
    this.title = "",
    this.isPlaying = false,
    this.currentDuration = Duration.zero,
    this.totalDuration = Duration.zero,
  });
  final bool isPlaying;
  final String title;
  final Duration currentDuration;
  final Duration totalDuration;

  @override
  List<Object?> get props => [
        title,
        isPlaying,
        currentDuration,
        totalDuration,
      ];

  QuiteTimeAudio copyWith({
    bool? isPlaying,
    String? title,
    Duration? position,
    Duration? duration,
  }) {
    return QuiteTimeAudio(
      isPlaying: isPlaying ?? this.isPlaying,
      title: title ?? this.title,
      currentDuration: position ?? this.currentDuration,
      totalDuration: duration ?? this.totalDuration,
    );
  }
}
