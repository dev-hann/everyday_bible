import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bible_event.dart';
part 'bible_state.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  BibleBloc() : super(const BibleState()) {
    on<BibleEventInited>(_onInited);
  }

  FutureOr<void> _onInited(BibleEventInited event, Emitter<BibleState> emit) {
    emit(
      state.copyWith(
        status: BibleViewStatus.success,
      ),
    );
  }
}
