import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Setting extends Equatable {
  const Setting({
    this.themeModeIndex = 2,
  });
  final int themeModeIndex;
  ThemeMode get themeMode => ThemeMode.values[themeModeIndex];
  bool get isDarkMode => themeMode == ThemeMode.dark;

  @override
  List<Object?> get props => [
        themeModeIndex,
      ];

  Map<String, dynamic> toMap() {
    return {
      "themeModeIndex": themeModeIndex,
    };
  }

  factory Setting.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Setting(
      themeModeIndex: data["themeModeIndex"],
    );
  }

  Setting copyWith({
    int? themeModeIndex,
  }) {
    return Setting(
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
    );
  }
}
