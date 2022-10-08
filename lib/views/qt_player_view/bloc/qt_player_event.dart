part of qt_player_bloc;

abstract class QTPlayerEvent extends Equatable {}

class QTPlayerInited extends QTPlayerEvent {
  QTPlayerInited({
    required this.title,
    required this.audioURL,
  });
  final String title;
  final String audioURL;

  @override
  List<Object?> get props => [
        title,
        audioURL,
      ];
}

class QTPlayerOnTapPlay extends QTPlayerEvent {
  @override
  List<Object?> get props => [];
}

class QTPlayerOnChangeDurationStart extends QTPlayerEvent {
  QTPlayerOnChangeDurationStart(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

class QTPlayerOnChangeDuration extends QTPlayerEvent {
  QTPlayerOnChangeDuration(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

class QTPlayerOnChangeDurationEnd extends QTPlayerEvent {
  QTPlayerOnChangeDurationEnd(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}
