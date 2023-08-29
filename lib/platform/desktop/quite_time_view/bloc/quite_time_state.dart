part of 'quite_time_bloc.dart';

enum QuiteTimeViewStatus {
  init,
  loading,
  failure,
  success,
}

class QuiteTimeState extends Equatable {
  const QuiteTimeState({
    this.status = QuiteTimeViewStatus.init,
  });
  final QuiteTimeViewStatus status;

  @override
  List<Object> get props => [
        status,
      ];

  QuiteTimeState copyWith({
    QuiteTimeViewStatus? status,
  }) {
    return QuiteTimeState(
      status: status ?? this.status,
    );
  }
}
