part of 'quite_time_bloc.dart';

abstract class QuiteTimeEvent extends Equatable {
  const QuiteTimeEvent();

  @override
  List<Object?> get props => [];
}

class QuiteTimeEventInited extends QuiteTimeEvent {
  const QuiteTimeEventInited();
}

class QuiteTimeEventUpdatedDateTime extends QuiteTimeEvent {
  const QuiteTimeEventUpdatedDateTime(this.dateTime);
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}
