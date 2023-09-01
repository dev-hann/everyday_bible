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
    this.quiteTime,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
  final QuiteTimeViewStatus status;
  final DateTime dateTime;
  final QuiteTime? quiteTime;

  @override
  List<Object?> get props => [
        status,
        dateTime,
        quiteTime,
      ];

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
