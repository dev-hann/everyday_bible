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
  });
  final QTViewStatus status;
  final QuiteTimeFormat? dateTime;
  final Map<String, QuiteTime> qtDataMap;
  QuiteTime? get qtData => qtDataMap[dateTime.toString()];
  @override
  List<Object?> get props => [
        status,
        dateTime,
        qtDataMap,
      ];

  QTState copyWith({
    QTViewStatus? status,
    QuiteTimeFormat? dateTime,
    Map<String, QuiteTime>? qtDataMap,
  }) {
    return QTState(
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      qtDataMap: qtDataMap ?? this.qtDataMap,
    );
  }
}
