part of 'memo_bloc.dart';

enum MemoViewStatus {
  init,
  loading,
  failure,
  success,
}

class MemoState extends Equatable {
  MemoState({
    this.status = MemoViewStatus.init,
    this.memoList = const [],
    this.selectedMemo,
    FocusNode? focusNode,
  }) : focusNode = focusNode ?? FocusNode();
  final MemoViewStatus status;
  final List<Memo> memoList;
  final Memo? selectedMemo;
  final FocusNode focusNode;

  @override
  List<Object?> get props => [
        status,
        memoList,
        selectedMemo,
        focusNode,
      ];

  MemoState copyWith({
    MemoViewStatus? status,
    List<Memo>? memoList,
    Memo? selectedMemo,
    FocusNode? focusNode,
  }) {
    return MemoState(
      status: status ?? this.status,
      memoList: memoList ?? this.memoList,
      selectedMemo: selectedMemo ?? this.selectedMemo,
      focusNode: focusNode ?? this.focusNode,
    );
  }
}
