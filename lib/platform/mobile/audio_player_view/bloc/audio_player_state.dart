part of 'audio_player_bloc.dart';

/// Lifecycle status of the audio player view.
enum AudioPlayerViewStatus {
  /// The player has not been initialized yet.
  init,

  /// The audio track is being loaded.
  loading,

  /// The audio track failed to load.
  failure,

  /// The audio track is ready to play.
  success,
}

/// State of the audio player: view status, playback state, and the date
/// whose meditation audio is loaded.
class AudioPlayerState extends Equatable {
  /// Creates the state, defaulting [dateTime] to the current time.
  AudioPlayerState({
    this.status = AudioPlayerViewStatus.init,
    this.audioState = const AudioState(),
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  /// Lifecycle status of the view.
  final AudioPlayerViewStatus status;

  /// Current playback state of the audio.
  final AudioState audioState;

  /// The date whose meditation audio is loaded.
  final DateTime dateTime;

  /// URL of the meditation mp3 for [dateTime].
  String get audioURL {
    return "https://meditation.su.or.kr/meditation_mp3/${dateTime.year}/${DateFormat("yyyyMMdd").format(dateTime)}.mp3";
  }

  @override
  List<Object> get props => [
        status,
        audioState,
        dateTime,
      ];

  /// Returns a copy of this state with the given fields replaced.
  AudioPlayerState copyWith({
    AudioPlayerViewStatus? status,
    AudioState? audioState,
    DateTime? dateTime,
  }) {
    return AudioPlayerState(
      status: status ?? this.status,
      audioState: audioState ?? this.audioState,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
