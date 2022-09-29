library home_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/use_case/bible_use_case/bible_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    BibleRepo bibleRepo,
  )   : bibleUseCase = BibleUseCase(bibleRepo),
        super(const HomeState()) {
    on<HomeInited>(_onInit);
  }

  final BibleUseCase bibleUseCase;

  FutureOr<void> _onInit(HomeInited event, Emitter<HomeState> emit) {
    print(bibleUseCase.isExistBibleDB());
  }
}
