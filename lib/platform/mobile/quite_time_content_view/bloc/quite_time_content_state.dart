part of 'quite_time_content_bloc.dart';

enum QuiteTimeViewStatus {
  init,
  loading,
  failure,
  success,
}

class QuiteTimeContentState extends Equatable {
  QuiteTimeContentState({
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

  QuiteTimeContentState copyWith({
    QuiteTimeViewStatus? status,
    DateTime? dateTime,
    QuiteTime? quiteTime,
  }) {
    return QuiteTimeContentState(
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      quiteTime: quiteTime ?? this.quiteTime,
    );
  }
}
