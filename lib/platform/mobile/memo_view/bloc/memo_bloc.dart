import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/use_case/memo_use_case/memo_use_case.dart';

part 'memo_event.dart';
part 'memo_state.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoBloc(MemoRepo repo)
      : useCase = MemoUseCase(repo),
        super(const MemoState()) {
    on<MemoEventInited>(_onInited);
    on<MemoEventUpdatedMemo>(_onUpdatedMemo);
  }
  final MemoUseCase useCase;

  FutureOr<void> _onInited(
      MemoEventInited event, Emitter<MemoState> emit) async {
    final either = useCase.loadMemoList();
    either.fold(
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
      MemoEventUpdatedMemo event, Emitter<MemoState> emit) async {
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
}
