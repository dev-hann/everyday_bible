part of qt_bloc;

enum QTViewStatus {
  init,
  loading,
  fail,
  success,
}

class QTState extends Equatable {
  const QTState({
    this.status = QTViewStatus.init,
    this.dateTime,
    this.qtDataMap = const {},
    this.audio = const QuiteTimeAudio(),
  });
  final QTViewStatus status;
  final QuiteTimeFormat? dateTime;
  final Map<String, QuiteTime> qtDataMap;
  QuiteTime? get qtData => qtDataMap[dateTime.toString()];
  final QuiteTimeAudio audio;
  @override
  List<Object?> get props => [
        status,
        dateTime,
        qtDataMap,
        audio,
      ];

  QTState copy({
    QTViewStatus? status,
    QuiteTimeFormat? dateTime,
    Map<String, QuiteTime>? qtDataMap,
    QuiteTimeAudio? audio,
  }) {
    return QTState(
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      qtDataMap: qtDataMap ?? this.qtDataMap,
      audio: audio ?? this.audio,
    );
  }
}
