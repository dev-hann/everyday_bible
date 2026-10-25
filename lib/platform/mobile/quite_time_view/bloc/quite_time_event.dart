part of 'quite_time_bloc.dart';

/// Base class for Quiet Time reader events.
abstract class QuiteTimeEvent extends Equatable {
  /// Creates a base Quiet Time reader event.
  const QuiteTimeEvent();

  @override
  List<Object?> get props => [];
}

/// Starts loading the Quiet Time content of a date.
class QuiteTimeEventInited extends QuiteTimeEvent {
  /// Creates an init event for [dateTime].
  const QuiteTimeEventInited(
    this.dateTime,
  );

  /// The date whose content to load.
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Reloads the content for a newly selected date.
class QuiteTimeEventUpdatedDateTime extends QuiteTimeEvent {
  /// Creates an event selecting [dateTime].
  const QuiteTimeEventUpdatedDateTime(this.dateTime);

  /// The newly selected date.
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}
