part of 'quite_time_dash_board_bloc.dart';

abstract class QuiteTimeDashBoardEvent extends Equatable {
  const QuiteTimeDashBoardEvent();

  @override
  List<Object> get props => [];
}

class QuiteTimeDashBoardEventInited extends QuiteTimeDashBoardEvent {
  const QuiteTimeDashBoardEventInited();
}

class QuiteTimeDashBoardEventChangedDateTime extends QuiteTimeDashBoardEvent {
  const QuiteTimeDashBoardEventChangedDateTime(this.dateTime);
  final DateTime dateTime;
  @override
  List<Object> get props => [dateTime];
}
