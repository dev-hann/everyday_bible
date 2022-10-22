part of setting_bloc;

abstract class SettingEvent extends Equatable {}

class SettingInited extends SettingEvent {
  @override
  List<Object?> get props => [];
}

class SettingOnChanged extends SettingEvent {
  SettingOnChanged(this.setting);
  final Setting setting;

  @override
  List<Object?> get props => [setting];
}
