import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// User-facing app settings: theme mode and text size.
class Setting extends Equatable {
  /// Creates settings, defaulting to dark mode and medium text.
  const Setting({
    this.themeMode = ThemeMode.dark,
    this.textScaleFactor = TextScaleFactor.medium,
  });

  /// Rebuilds settings from persisted map values, falling back to defaults.
  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      themeMode: ThemeMode.values[_toInt(map['themeMode']) ?? 2],
      textScaleFactor:
          TextScaleFactor.values[_toInt(map['textScaleFactor']) ?? 1],
    );
  }

  /// Theme mode (light/dark/system) applied to the app.
  final ThemeMode themeMode;

  /// Selected text size step.
  final TextScaleFactor textScaleFactor;

  @override
  List<Object?> get props => [
        themeMode,
        textScaleFactor,
      ];

  /// Returns a copy of this setting with the given fields replaced.
  Setting copyWith({
    ThemeMode? themeMode,
    TextScaleFactor? textScaleFactor,
  }) {
    return Setting(
      themeMode: themeMode ?? this.themeMode,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }

  /// Serializes the setting for persistence.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeMode': themeMode.index,
      'textScaleFactor': textScaleFactor.index,
    };
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Text size steps offered in settings.
enum TextScaleFactor {
  /// Smallest text (0.8x).
  small,

  /// Default text (1.0x).
  medium,

  /// Largest text (1.2x).
  large,
}

/// Presentation helpers for [TextScaleFactor].
extension FactorExtension on TextScaleFactor {
  /// Returns the UI label of this step (`Small`, `Medium`, `Large`).
  String toName() {
    switch (this) {
      case TextScaleFactor.small:
        return 'Small';
      case TextScaleFactor.medium:
        return 'Medium';
      case TextScaleFactor.large:
        return 'Large';
    }
  }

  /// Returns the text scale multiplier of this step (0.8, 1, or 1.2).
  double toScaleFactor() {
    switch (this) {
      case TextScaleFactor.small:
        return 0.8;
      case TextScaleFactor.medium:
        return 1;
      case TextScaleFactor.large:
        return 1.2;
    }
  }
}
