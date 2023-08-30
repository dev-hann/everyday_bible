part of 'setting_bloc.dart';

enum SettingViewStatus {
  init,
  loading,
  failure,
  success,
}

class SettingState extends Equatable {
  const SettingState({
    this.status = SettingViewStatus.init,
  });
  final SettingViewStatus status;

  @override
  List<Object> get props => [
        status,
      ];

  SettingState copyWith({
    SettingViewStatus? status,
  }) {
    return SettingState(
      status: status ?? this.status,
    );
  }
}
