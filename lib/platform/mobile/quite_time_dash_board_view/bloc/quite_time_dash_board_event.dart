part of 'quite_time_dash_board_bloc.dart';

/// Base class for Quiet Time dashboard events.
abstract class QuiteTimeDashBoardEvent extends Equatable {
  /// Creates a base dashboard event.
  const QuiteTimeDashBoardEvent();

  @override
  List<Object> get props => [];
}

/// Initializes the dashboard for the currently selected date.
class QuiteTimeDashBoardEventInited extends QuiteTimeDashBoardEvent {
  /// Creates an init event.
  const QuiteTimeDashBoardEventInited();
}

/// Selects a new date on the dashboard calendar.
class QuiteTimeDashBoardEventChangedDateTime extends QuiteTimeDashBoardEvent {
  /// Creates an event selecting [dateTime].
  const QuiteTimeDashBoardEventChangedDateTime(this.dateTime);

  /// The newly selected date.
  final DateTime dateTime;

  @override
  List<Object> get props => [dateTime];
}
