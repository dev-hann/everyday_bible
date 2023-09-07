import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEventInited>(_onInited);
    on<HomeEventUpdatedIndex>(_onUpdatedIndex);
  }

  FutureOr<void> _onInited(HomeEventInited event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        status: HomeViewStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdatedIndex(
      HomeEventUpdatedIndex event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        status: HomeViewStatus.success,
        menuIndex: event.index,
      ),
    );
  }
}
