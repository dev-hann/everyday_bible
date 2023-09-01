import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/bible/bible_chapter.dart';
import 'package:everydaybible/models/bible/bible_data.dart';
import 'package:everydaybible/models/bible/bible_verse.dart';
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
    final either = await useCase.requestBibleData();
    either.fold(
      (fail) {},
      (list) {
        emit(
          state.copyWith(
            status: BibleViewStatus.success,
            bibleDataList: list,
          ),
        );
      },
    );
    add(BibleEventUpdatedChapter(state.bibleDataList.first.chatperList.first));
  }

  FutureOr<void> _onUpdatedChapter(
      BibleEventUpdatedChapter event, Emitter<BibleState> emit) async {
    final chapter = event.chapter;
    emit(
      state.copyWith(
        currentChapter: chapter,
      ),
    );
    final either = await useCase.requestVerseList(chapter);
    either.fold(
      (fail) {},
      (list) {
        emit(
          state.copyWith(
            verseList: list,
          ),
        );
      },
    );
  }
}
