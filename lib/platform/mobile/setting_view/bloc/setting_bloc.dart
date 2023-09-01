import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/setting.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingState()) {
    on<SettingEventInited>(_onInited);
    on<SettingEventUpdatedSetting>(_onUpdatedSetting);
  }

  FutureOr<void> _onInited(
      SettingEventInited event, Emitter<SettingState> emit) {
    emit(
      state.copyWith(
        status: SettingViewStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdatedSetting(
      SettingEventUpdatedSetting event, Emitter<SettingState> emit) {
    emit(
      state.copyWith(
        setting: event.setting,
      ),
    );
  }
}
