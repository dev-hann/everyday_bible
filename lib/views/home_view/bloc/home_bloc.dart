library home_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeInited>(_onInit);
  }

  FutureOr<void> _onInit(HomeInited event, Emitter<HomeState> emit) {

  }
}
