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
}
