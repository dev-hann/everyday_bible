part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object?> get props => [];
}

class AudioPlayerEventInited extends AudioPlayerEvent {
  const AudioPlayerEventInited();
}

class AudioPlayerEventLoadedAudio extends AudioPlayerEvent {}

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

class AudioPlayerEventPlayed extends AudioPlayerEvent {}

class AudioPlayerEventPaused extends AudioPlayerEvent {}
