import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/use_case/bible_use_case/bible_use_case.dart';
import 'package:fluent_ui/fluent_ui.dart';

part 'bible_event.dart';
part 'bible_state.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  BibleBloc(BibleRepo repo)
      : useCase = BibleUseCase(repo),
        super(BibleState()) {
    on<BibleEventInited>(_onInited);
    on<BibleEventUpdatedChapter>(_onUpdatedChapter);
  }
  final BibleUseCase useCase;

  FutureOr<void> _onInited(
      BibleEventInited event, Emitter<BibleState> emit) async {
    await useCase.initDataBase();

    final either = useCase.loadBibleDataList();
    either.fold(
      (fail) {},
      (list) {
        emit(
          state.copyWith(
            status: BibleViewStatus.loading,
            bibleDataList: list,
          ),
        );
      },
    );
    final data = state.bibleDataList.first;
    final chapter = data.chapterList.first;
    add(
      BibleEventUpdatedChapter(
        data,
        chapter,
      ),
    );
  }

  FutureOr<void> _onUpdatedChapter(
      BibleEventUpdatedChapter event, Emitter<BibleState> emit) async {
    emit(
      state.copyWith(
        status: BibleViewStatus.success,
        selectedData: event.data,
        selectedChapter: event.chapter,
      ),
    );
    await WidgetsBinding.instance.endOfFrame;
    state.scrollController.jumpTo(0);
  }
}
