part of 'quite_time_bloc.dart';

/// Lifecycle status of the Quiet Time reader view.
enum QuiteTimeViewStatus {
  /// The reader has not been initialized yet.
  init,

  /// The day's content is being loaded.
  loading,

  /// Loading the day's content failed.
  failure,

  /// The day's content is loaded and shown.
  success,
}

/// State of the Quiet Time reader: the selected date and its loaded
/// content.
class QuiteTimeState extends Equatable {
  /// Creates the state, defaulting [dateTime] to now.
  QuiteTimeState({
    this.status = QuiteTimeViewStatus.init,
    this.quiteTime,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  /// Lifecycle status of the view.
  final QuiteTimeViewStatus status;

  /// The date whose content is shown.
  final DateTime dateTime;

  /// The loaded content of [dateTime], if loaded.
  final QuiteTime? quiteTime;

  @override
  List<Object?> get props => [
        status,
        dateTime,
        quiteTime,
      ];

  /// Returns a copy of this state with the given fields replaced.
  QuiteTimeState copyWith({
    QuiteTimeViewStatus? status,
    DateTime? dateTime,
    QuiteTime? quiteTime,
  }) {
    return QuiteTimeState(
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      quiteTime: quiteTime ?? this.quiteTime,
    );
  }
}
