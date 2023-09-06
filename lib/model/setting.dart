import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:everydaybible/enum/text_scale_factor.dart';

class Setting extends Equatable {
  const Setting({
    this.themeMode = ThemeMode.dark,
    this.textScaleFactor = TextScaleFactor.medium,
  });
  final ThemeMode themeMode;
  final TextScaleFactor textScaleFactor;
  @override
  List<Object?> get props => [
        themeMode,
        textScaleFactor,
      ];

  Setting copyWith({
    ThemeMode? themeMode,
    TextScaleFactor? textScaleFactor,
  }) {
    return Setting(
      themeMode: themeMode ?? this.themeMode,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeMode': themeMode.index,
      'textScaleFactor': textScaleFactor.index,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      themeMode: ThemeMode.values[map['brightness']],
      textScaleFactor: TextScaleFactor.values[map['textScaleFactor']],
    );
  }
}
