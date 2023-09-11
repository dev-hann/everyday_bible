import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';

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

enum TextScaleFactor {
  small,
  medium,
  large,
}

extension FactorExtension on TextScaleFactor {
  String toName() {
    switch (this) {
      case TextScaleFactor.small:
        return "Small";
      case TextScaleFactor.medium:
        return "Medium";
      case TextScaleFactor.large:
        return "Large";
    }
  }

  double toScaleFactor() {
    switch (this) {
      case TextScaleFactor.small:
        return 0.8;
      case TextScaleFactor.medium:
        return 1.0;
      case TextScaleFactor.large:
        return 1.2;
    }
  }
}
