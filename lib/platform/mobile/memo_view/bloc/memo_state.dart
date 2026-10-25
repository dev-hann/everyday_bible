part of 'memo_bloc.dart';

/// Lifecycle status of the memo list view.
enum MemoViewStatus {
  /// The memo list has not been loaded yet.
  init,

  /// The memo list is being loaded.
  loading,

  /// Loading the memo list failed.
  failure,

  /// The memo list is loaded and shown.
  success,
}

/// State of the memo list: all memos and the most recently saved one.
class MemoState extends Equatable {
  /// Creates the state with an empty memo list.
  const MemoState({
    this.status = MemoViewStatus.init,
    this.memoList = const [],
    this.selectedMemo,
  });

  /// Lifecycle status of the view.
  final MemoViewStatus status;

  /// All stored memos.
  final List<Memo> memoList;

  /// The memo most recently saved, if any.
  final Memo? selectedMemo;

  @override
  List<Object?> get props => [
        status,
        memoList,
        selectedMemo,
      ];

  /// Returns a copy of this state with the given fields replaced.
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
