part of 'quite_time_dash_board_bloc.dart';

/// Lifecycle status of the Quiet Time dashboard view.
enum QuiteTimeDashBoardViewStatus {
  /// The dashboard has not been initialized yet.
  init,

  /// The day's data is being loaded.
  loading,

  /// Loading the day's data failed.
  failure,

  /// The day's data is loaded and shown.
  success,
}

/// State of the dashboard: the loaded days and the selected date.
class QuiteTimeDashBoardState extends Equatable {
  /// Creates the state, defaulting [selectedDateTime] to now.
  QuiteTimeDashBoardState({
    this.status = QuiteTimeDashBoardViewStatus.init,
    this.dataList = const [],
    DateTime? selectedDateTime,
  }) : selectedDateTime = selectedDateTime ?? DateTime.now();

  /// Lifecycle status of the view.
  final QuiteTimeDashBoardViewStatus status;

  /// Quiet Time data of each loaded day.
  final List<QuiteTimeData> dataList;

  /// The date selected on the calendar.
  final DateTime selectedDateTime;

  @override
  List<Object> get props => [
        status,
        dataList,
        selectedDateTime,
      ];

  /// Returns a copy of this state with the given fields replaced.
  QuiteTimeDashBoardState copyWith({
    QuiteTimeDashBoardViewStatus? status,
    List<QuiteTimeData>? dataList,
    DateTime? selectedDateTime,
  }) {
    return QuiteTimeDashBoardState(
      status: status ?? this.status,
      dataList: dataList ?? this.dataList,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
    );
  }
}
