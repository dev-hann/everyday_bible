part of 'quite_time_bloc.dart';

abstract class QuiteTimeEvent extends Equatable {
  const QuiteTimeEvent();

  @override
  List<Object> get props => [];
}

class QuiteTimeEventInited extends QuiteTimeEvent {
  const QuiteTimeEventInited();
}
