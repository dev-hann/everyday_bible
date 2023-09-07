part of 'memo_bloc.dart';

abstract class MemoEvent extends Equatable {
  const MemoEvent();

  @override
  List<Object> get props => [];
}

class MemoEventInited extends MemoEvent {
  const MemoEventInited();
}

class MemoEventUpdatedMemo extends MemoEvent {
  const MemoEventUpdatedMemo(this.memo);
  final Memo memo;
  @override
  List<Object> get props => [memo];
}

class MemoEventRemoveddMemo extends MemoEvent {
  const MemoEventRemoveddMemo(this.memo);
  final Memo memo;
  @override
  List<Object> get props => [memo];
}

class MemoEventInitedEdit extends MemoEvent {
  const MemoEventInitedEdit();
}
