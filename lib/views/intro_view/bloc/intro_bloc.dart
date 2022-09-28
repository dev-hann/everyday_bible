library intro_bloc;

import 'package:equatable/equatable.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/use_case/bible_use_case/bible_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  IntroBloc(
    BibleRepo bibleRepo,
  )   : bibleUseCase = BibleUseCase(bibleRepo),
        super(IntroState());
  final BibleUseCase bibleUseCase;
}
