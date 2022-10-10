part of bible_bloc;

enum BibleViewStatus {
  init,
  loading,
  fail,
  success,
}

class BibleState extends Equatable {
  const BibleState({
    this.status = BibleViewStatus.init,
    this.tabIndex = 0,
  });
  final BibleViewStatus status;
  final int tabIndex;
  @override
  List<Object?> get props => [
        status,
        tabIndex,
      ];
  BibleState copyWith({
    BibleViewStatus? status,
    int? tabIndex,
  }) {
    return BibleState(
      status: status ?? this.status,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
