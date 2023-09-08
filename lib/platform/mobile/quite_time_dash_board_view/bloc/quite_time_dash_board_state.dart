part of 'quite_time_dash_board_bloc.dart';

enum QuiteTimeDashBoardViewStatus {
  init,
  loading,
  failure,
  success,
}

class QuiteTimeDashBoardState extends Equatable {
  QuiteTimeDashBoardState({
    this.status = QuiteTimeDashBoardViewStatus.init,
    this.dataList = const [],
    DateTime? selectedDateTime,
  }) : selectedDateTime = selectedDateTime ?? DateTime.now();
  final QuiteTimeDashBoardViewStatus status;
  final List<QuiteTimeData> dataList;
  final DateTime selectedDateTime;

  @override
  List<Object> get props => [
        status,
        dataList,
        selectedDateTime,
      ];

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
