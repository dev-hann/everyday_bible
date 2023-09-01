part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class SettingEventInited extends SettingEvent {}

class SettingEventUpdatedSetting extends SettingEvent {
  const SettingEventUpdatedSetting(this.setting);
  final Setting setting;

  @override
  List<Object> get props => [setting];
}
