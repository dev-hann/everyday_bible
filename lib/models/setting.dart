import 'package:equatable/equatable.dart';
import 'package:everydaybible/enum/text_scale_factor.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Setting extends Equatable {
  const Setting({
    this.themeModeIndex = 2,
    this.textScaleFactorIndex = 1,
  });
  final int themeModeIndex;
  ThemeMode get themeMode => ThemeMode.values[themeModeIndex];
  bool get isDarkMode => themeMode == ThemeMode.dark;

  final int textScaleFactorIndex;
  TextScaleFactor get textScaleFactor =>
      TextScaleFactor.values[textScaleFactorIndex];
  @override
  List<Object?> get props => [
        themeModeIndex,
        textScaleFactorIndex,
      ];

  Map<String, dynamic> toMap() {
    return {
      "themeModeIndex": themeModeIndex,
      "textScaleFactorIndex": textScaleFactorIndex,
    };
  }

  factory Setting.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Setting(
      themeModeIndex: data["themeModeIndex"],
      textScaleFactorIndex: data["textScaleFactorIndex"],
    );
  }

  Setting copyWith({
    int? themeModeIndex,
    int? textScaleFactorIndex,
  }) {
    return Setting(
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      textScaleFactorIndex: textScaleFactorIndex ?? this.textScaleFactorIndex,
    );
  }
}
