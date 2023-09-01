import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/enum/mobile_menu_type.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEventInited>(_onInited);
    on<HomeEventUpdatedMenu>(_onUpdatedMenu);
  }

  FutureOr<void> _onInited(HomeEventInited event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        status: HomeViewStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdatedMenu(
      HomeEventUpdatedMenu event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        status: HomeViewStatus.success,
        menuType: event.type,
      ),
    );
  }
}
