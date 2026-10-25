import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/use_case/memo_use_case/memo_use_case.dart';

part 'memo_event.dart';
part 'memo_state.dart';

/// Manages the stored memos: loading the list and saving or deleting memos.
class MemoBloc extends Bloc<MemoEvent, MemoState> {
  /// Creates the bloc backed by [repo].
  MemoBloc(MemoRepo repo)
      : useCase = MemoUseCase(repo),
        super(const MemoState()) {
    on<MemoEventInited>(_onInited);
    on<MemoEventUpdatedMemo>(_onUpdatedMemo);
    on<MemoEventRemovedMemo>(_onRemovedMemo);
  }

  /// Use case wrapping the memo repository.
  final MemoUseCase useCase;

  FutureOr<void> _onInited(
    MemoEventInited event,
    Emitter<MemoState> emit,
  ) async {
    useCase.loadMemoList().fold(
      (fail) {},
      (list) {
        emit(
          state.copyWith(
            status: MemoViewStatus.success,
            memoList: list,
          ),
        );
      },
    );

    await emit.onEach(
      useCase.memoListStream(),
      onData: (list) {
        emit(
          state.copyWith(
            status: MemoViewStatus.success,
            memoList: list,
          ),
        );
      },
    );
  }

  FutureOr<void> _onUpdatedMemo(
    MemoEventUpdatedMemo event,
    Emitter<MemoState> emit,
  ) async {
    final option = await useCase.updateMemo(event.memo);
    option.fold(
      () {
        emit(
          state.copyWith(
            selectedMemo: event.memo,
          ),
        );
      },
      (fail) {},
    );
  }

  FutureOr<void> _onRemovedMemo(
    MemoEventRemovedMemo event,
    Emitter<MemoState> emit,
  ) {
    unawaited(useCase.removeMemo(event.memo));
  }
}
