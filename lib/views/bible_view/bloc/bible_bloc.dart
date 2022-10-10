library bible_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/use_case/bible_use_case/bible_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bible_state.dart';
part 'bible_event.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  BibleBloc(
    BibleRepo bibleRepo,
  )   : bibleUseCase = BibleUseCase(bibleRepo),
        super(const BibleState()) {
    on<BibleInited>(_onInit);
    on<BibleOnTapTab>(_onTapTab);
  }

  final BibleUseCase bibleUseCase;

  FutureOr<void> _onInit(BibleInited event, Emitter<BibleState> emit) async {
    await bibleUseCase.init();
    emit(
      state.copyWith(
        status: BibleViewStatus.success,
      ),
    );
  }

  FutureOr<void> _onTapTab(BibleOnTapTab event, Emitter<BibleState> emit) {
    emit(
      state.copyWith(
        tabIndex: event.index,
      ),
    );
  }
}
