part of 'audio_player_bloc.dart';

enum AudioPlayerViewStatus {
  init,
  loading,
  failure,
  success,
}

class AudioPlayerState extends Equatable {
  AudioPlayerState({
    this.status = AudioPlayerViewStatus.init,
    this.audioState = const AudioState(),
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
  final AudioPlayerViewStatus status;
  final AudioState audioState;
  final DateTime dateTime;

  String get audioURL {
    return "https://meditation.su.or.kr/meditation_mp3/${dateTime.year}/${DateFormat("yyy-MM-dd").format(dateTime)}.mp3";
  }

  @override
  List<Object> get props => [
        status,
        audioState,
        dateTime,
      ];

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
