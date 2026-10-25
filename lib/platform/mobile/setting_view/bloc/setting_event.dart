part of 'setting_bloc.dart';

/// Base class for settings events.
abstract class SettingEvent extends Equatable {
  /// Creates a base settings event.
  const SettingEvent();

  @override
  List<Object> get props => [];
}

/// Marks the settings view as ready.
class SettingEventInited extends SettingEvent {
  /// Creates an init event.
  const SettingEventInited();
}

/// Applies new settings.
class SettingEventUpdatedSetting extends SettingEvent {
  /// Creates an event with the new [setting].
  const SettingEventUpdatedSetting(this.setting);

  /// The settings to apply.
  final Setting setting;

  @override
  List<Object> get props => [setting];
}
