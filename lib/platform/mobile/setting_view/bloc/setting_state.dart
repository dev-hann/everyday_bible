part of 'setting_bloc.dart';

/// Lifecycle status of the settings view.
enum SettingViewStatus {
  /// The settings view has not been initialized yet.
  init,

  /// The settings view is being prepared.
  loading,

  /// Preparing the settings view failed.
  failure,

  /// The settings view is ready.
  success,
}

/// State of the settings view, holding the current settings.
class SettingState extends Equatable {
  /// Creates the state with default settings.
  const SettingState({
    this.status = SettingViewStatus.init,
    this.setting = const Setting(),
  });

  /// Lifecycle status of the view.
  final SettingViewStatus status;

  /// The current app settings.
  final Setting setting;

  @override
  List<Object> get props => [
        status,
        setting,
      ];

  /// Returns a copy of this state with the given fields replaced.
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
