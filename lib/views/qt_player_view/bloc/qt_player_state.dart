part of qt_player_bloc;

enum QTPlayerViewStatus {
  init,
  loading,
  fail,
  success,
}

class QTPlayerState extends Equatable {
  const QTPlayerState({
    this.status = QTPlayerViewStatus.init,
    this.audio = const QuiteTimeAudio(),
    this.isChangingDuration = false,
  });
  final QTPlayerViewStatus status;
  final QuiteTimeAudio audio;
  final bool isChangingDuration;
  @override
  List<Object?> get props => [
        status,
        audio,
      ];
  QTPlayerState copyWith({
    QTPlayerViewStatus? status,
    QuiteTimeAudio? audio,
    bool? isChangingDuration,
  }) {
    return QTPlayerState(
      status: status ?? this.status,
      audio: audio ?? this.audio,
      isChangingDuration: isChangingDuration ?? this.isChangingDuration,
    );
  }
}
