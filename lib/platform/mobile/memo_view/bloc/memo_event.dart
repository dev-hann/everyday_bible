part of 'memo_bloc.dart';

/// Base class for memo list events.
abstract class MemoEvent extends Equatable {
  /// Creates a base memo list event.
  const MemoEvent();

  @override
  List<Object> get props => [];
}

/// Loads the stored memos and listens for changes.
class MemoEventInited extends MemoEvent {
  /// Creates an init event.
  const MemoEventInited();
}

/// Saves the edited memo.
class MemoEventUpdatedMemo extends MemoEvent {
  /// Creates an event saving [memo].
  const MemoEventUpdatedMemo(this.memo);

  /// The edited memo to store.
  final Memo memo;

  @override
  List<Object> get props => [memo];
}

/// Deletes a memo.
class MemoEventRemovedMemo extends MemoEvent {
  /// Creates an event deleting [memo].
  const MemoEventRemovedMemo(this.memo);

  /// The memo to delete.
  final Memo memo;

  @override
  List<Object> get props => [memo];
}
