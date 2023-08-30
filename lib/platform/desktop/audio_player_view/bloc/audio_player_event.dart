part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
}

class AudioPlayerEventInited extends AudioPlayerEvent {
  const AudioPlayerEventInited();

  @override
  List<Object?> get props => [];
}

class AudioPlayerEventLoadedAudio extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class AudioPlayerEventSeekPosition extends AudioPlayerEvent {
  const AudioPlayerEventSeekPosition(this.duration);
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

class AudioPlayerEventChangedVolume extends AudioPlayerEvent {
  const AudioPlayerEventChangedVolume(this.volume);
  final double volume;

  @override
  List<Object?> get props => [volume];
}
