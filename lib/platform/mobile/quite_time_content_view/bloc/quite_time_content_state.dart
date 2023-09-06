part of 'quite_time_content_bloc.dart';

enum QuiteTimeContentViewStatus {
  init,
  loading,
  failure,
  success,
}

class QuiteTimeContentState extends Equatable {
  QuiteTimeContentState({
    this.status = QuiteTimeContentViewStatus.init,
    this.quiteTime,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
  final QuiteTimeContentViewStatus status;
  final DateTime dateTime;
  final QuiteTime? quiteTime;

  @override
  List<Object?> get props => [
        status,
        dateTime,
        quiteTime,
      ];

  QuiteTimeContentState copyWith({
    QuiteTimeContentViewStatus? status,
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
