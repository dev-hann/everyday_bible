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

/// Loads the Bible books and tracks the book and chapter shown in the
/// reader.
class BibleBloc extends Bloc<BibleEvent, BibleState> {
  /// Creates the bloc backed by [repo].
  BibleBloc(BibleRepo repo)
      : useCase = BibleUseCase(repo),
        super(BibleState()) {
    on<BibleEventInited>(_onInited);
    on<BibleEventUpdatedChapter>(_onUpdatedChapter);
  }

  /// Use case wrapping the Bible repository.
  final BibleUseCase useCase;

  FutureOr<void> _onInited(
    BibleEventInited event,
    Emitter<BibleState> emit,
  ) async {
    await useCase.initDataBase();
    useCase.loadBibleDataList().fold(
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
    BibleEventUpdatedChapter event,
    Emitter<BibleState> emit,
  ) async {
    final chapter = event.chapter;
    emit(
      state.copyWith(
        status: BibleViewStatus.success,
        selectedData: event.data,
        selectedChapter: chapter,
      ),
    );
  }
}
