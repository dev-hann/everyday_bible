part of 'memo_bloc.dart';

enum MemoViewStatus {
  init,
  loading,
  failure,
  success,
}

class MemoState extends Equatable {
  const MemoState({
    this.status = MemoViewStatus.init,
    this.memoList = const [],
    this.selectedMemo,
  });
  final MemoViewStatus status;
  final List<Memo> memoList;
  final Memo? selectedMemo;

  @override
  List<Object?> get props => [
        status,
        memoList,
        selectedMemo,
      ];

  MemoState copyWith({
    MemoViewStatus? status,
    List<Memo>? memoList,
    Memo? selectedMemo,
  }) {
    return MemoState(
      status: status ?? this.status,
      memoList: memoList ?? this.memoList,
      selectedMemo: selectedMemo ?? this.selectedMemo,
    );
  }
}
