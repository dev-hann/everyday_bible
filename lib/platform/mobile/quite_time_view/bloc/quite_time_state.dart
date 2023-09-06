part of 'quite_time_bloc.dart';

enum QuiteTimeViewStatus {
  init,
  loading,
  failure,
  success,
}

class QuiteTimeState extends Equatable {
  QuiteTimeState({
    this.status = QuiteTimeViewStatus.init,
    this.dataList = const [],
    DateTime? selectedDateTime,
  }) : selectedDateTime = selectedDateTime ?? DateTime.now();
  final QuiteTimeViewStatus status;
  final List<QuiteTimeData> dataList;
  final DateTime selectedDateTime;

  @override
  List<Object> get props => [
        status,
        dataList,
        selectedDateTime,
      ];

  QuiteTimeState copyWith({
    QuiteTimeViewStatus? status,
    List<QuiteTimeData>? dataList,
    DateTime? selectedDateTime,
  }) {
    return QuiteTimeState(
      status: status ?? this.status,
      dataList: dataList ?? this.dataList,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
    );
  }
}
