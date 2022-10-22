part of setting_bloc;

enum SettingViewStatus {
  init,
  loading,
  fail,
  success,
}

class SettingState extends Equatable {
  const SettingState({
    this.status = SettingViewStatus.init,
    this.setting = const Setting(),
  });
  final SettingViewStatus status;
  final Setting setting;
  @override
  List<Object?> get props => [
        status,
        setting,
      ];

  SettingState copyWith({
    SettingViewStatus? status,
    Setting? setting,
  }) {
    return SettingState(
      status: status ?? this.status,
      setting: setting ?? this.setting,
    );
  }
}
