part of qt_bloc;

abstract class QTEvent extends Equatable {}

class QTOnInited extends QTEvent {
  @override
  List<Object?> get props => [];
}

class QTOnChangedDuration extends QTEvent{
  QTOnChangedDuration(this.value);
  final double value;

  @override
  List<Object?> get props => [];

}
class QTOnTapPlay extends QTEvent{
  @override
  List<Object?> get props => [];

}
