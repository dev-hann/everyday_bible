import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/use_case/memo_use_case/memo_use_case.dart';
import 'package:fluent_ui/fluent_ui.dart';

part 'memo_event.dart';
part 'memo_state.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoBloc(MemoRepo repo)
      : useCase = MemoUseCase(repo),
        super(MemoState()) {
    on<MemoEventInited>(_onInited);
    on<MemoEventUpdatedMemo>(_onUpdatedMemo);
    on<MemoEventInitedEdit>(_onInitedEdit);
    on<MemoEventRemoveddMemo>(_onRemovedMemo);
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

    add(const MemoEventInitedEdit());
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

  FutureOr<void> _onRemovedMemo(
      MemoEventRemoveddMemo event, Emitter<MemoState> emit) {
    final memo = event.memo;
    useCase.removeMemo(memo);
  }

  FutureOr<void> _onInitedEdit(
      MemoEventInitedEdit event, Emitter<MemoState> emit) {
    DesktopMultiWindow.setMethodHandler(
      (call, fromWindowId) async {
        final method = call.method;
        final arg = call.arguments;
        if (method == "onUpdated") {
          final memo = Memo.fromMap(jsonDecode(arg));
          add(MemoEventUpdatedMemo(memo));
        }
      },
    );
  }
}
