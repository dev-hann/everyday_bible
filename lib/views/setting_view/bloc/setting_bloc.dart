library setting_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/setting.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/use_case/setting_use_case/setting_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(
    SettingRepo settingRepo,
  )   : settingUseCase = SettingUseCase(settingRepo),
        super(const SettingState()) {
    on<SettingInited>(_onInit);
    on<SettingOnChanged>(_onChangedSetting);
  }
  final SettingUseCase settingUseCase;

  FutureOr<void> _onInit(SettingInited event, Emitter<SettingState> emit) {
    final setting = settingUseCase.loadSetting();
    emit(
      state.copyWith(
        status: SettingViewStatus.success,
        setting: setting,
      ),
    );
  }

  FutureOr<void> _onChangedSetting(
      SettingOnChanged event, Emitter<SettingState> emit) {
    emit(
      state.copyWith(
        setting: event.setting,
      ),
    );
  }
}
