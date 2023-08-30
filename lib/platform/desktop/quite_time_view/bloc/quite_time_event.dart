part of 'quite_time_bloc.dart';

abstract class QuiteTimeEvent extends Equatable {
  const QuiteTimeEvent();
}

class QuiteTimeEventInited extends QuiteTimeEvent {
  const QuiteTimeEventInited();
  @override
  List<Object?> get props => [];
}

class QuiteTimeEventUpdatedDateTime extends QuiteTimeEvent {
  const QuiteTimeEventUpdatedDateTime(this.dateTime);
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}
