part of 'bible_bloc.dart';

enum BibleViewStatus {
  init,
  loading,
  failure,
  success,
}

class BibleState extends Equatable {
  const BibleState({
    this.status = BibleViewStatus.init,
  });
  final BibleViewStatus status;

  @override
  List<Object> get props => [
        status,
      ];

  BibleState copyWith({
    BibleViewStatus? status,
  }) {
    return BibleState(
      status: status ?? this.status,
    );
  }
}
