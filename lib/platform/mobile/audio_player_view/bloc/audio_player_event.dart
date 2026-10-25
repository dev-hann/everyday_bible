part of 'audio_player_bloc.dart';

/// Base class for audio player events.
abstract class AudioPlayerEvent extends Equatable {
  /// Creates a base audio player event.
  const AudioPlayerEvent();

  @override
  List<Object?> get props => [];
}

/// Re-initializes the player for a new date, stopping any current audio.
class AudioPlayerEventInited extends AudioPlayerEvent {
  /// Creates an init event for [dateTime].
  const AudioPlayerEventInited(this.dateTime);

  /// The date whose meditation audio should be played.
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Loads the meditation audio of the currently selected date.
class AudioPlayerEventLoadedAudio extends AudioPlayerEvent {}

/// Moves the playback position to [duration].
class AudioPlayerEventSeekPosition extends AudioPlayerEvent {
  /// Creates a seek event to [duration].
  const AudioPlayerEventSeekPosition(this.duration);

  /// The playback position to seek to.
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

/// Sets the playback volume.
class AudioPlayerEventChangedVolume extends AudioPlayerEvent {
  /// Creates a volume change event to [volume].
  const AudioPlayerEventChangedVolume(this.volume);

  /// The new volume, between 0.0 and 1.0.
  final double volume;

  @override
  List<Object?> get props => [volume];
}

/// Starts or resumes playback.
class AudioPlayerEventPlayed extends AudioPlayerEvent {}

/// Pauses playback.
class AudioPlayerEventPaused extends AudioPlayerEvent {}
