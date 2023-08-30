import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingState()) {
    on<SettingEventInited>(_onInited);
  }

  FutureOr<void> _onInited(
      SettingEventInited event, Emitter<SettingState> emit) {
    emit(
      state.copyWith(
        status: SettingViewStatus.success,
      ),
    );
  }
}
