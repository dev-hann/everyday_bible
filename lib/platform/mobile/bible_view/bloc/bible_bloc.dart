import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/use_case/bible_use_case/bible_use_case.dart';
import 'package:flutter/material.dart';

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
    add(
      BibleEventUpdatedChapter(
        state.bibleDataList.first.chapterList.first,
      ),
    );
  }

  FutureOr<void> _onUpdatedChapter(
      BibleEventUpdatedChapter event, Emitter<BibleState> emit) async {
    final chapter = event.chapter;
    emit(
      state.copyWith(
        status: BibleViewStatus.success,
        selectedChapter: chapter,
      ),
    );
  }
}
