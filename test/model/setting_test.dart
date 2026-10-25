import 'package:everydaybible/model/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Setting defaults', () {
    test('defaults to dark theme and medium text', () {
      const setting = Setting();

      expect(setting.themeMode, ThemeMode.dark);
      expect(setting.textScaleFactor, TextScaleFactor.medium);
    });
  });

  group('Setting.fromMap', () {
    test('parses int indexes', () {
      final setting = Setting.fromMap(
        const <String, dynamic>{'themeMode': 1, 'textScaleFactor': 2},
      );

      expect(setting.themeMode, ThemeMode.light);
      expect(setting.textScaleFactor, TextScaleFactor.large);
    });

    test('parses numeric string indexes', () {
      final setting = Setting.fromMap(
        const <String, dynamic>{'themeMode': '0', 'textScaleFactor': '0'},
      );

      expect(setting.themeMode, ThemeMode.system);
      expect(setting.textScaleFactor, TextScaleFactor.small);
    });

    test('falls back to defaults on missing keys', () {
      final setting = Setting.fromMap(const <String, dynamic>{});

      expect(setting.themeMode, ThemeMode.dark);
      expect(setting.textScaleFactor, TextScaleFactor.medium);
    });

    test('falls back to defaults on unparsable values', () {
      final setting = Setting.fromMap(
        const <String, dynamic>{
          'themeMode': 'not-a-number',
          'textScaleFactor': null,
        },
      );

      expect(setting.themeMode, ThemeMode.dark);
      expect(setting.textScaleFactor, TextScaleFactor.medium);
    });

    test('throws RangeError on out-of-range indexes (current behavior)', () {
      expect(
        () => Setting.fromMap(const <String, dynamic>{'themeMode': 99}),
        throwsA(isA<RangeError>()),
      );
    });
  });

  group('Setting serialization', () {
    test('toMap serializes enum indexes', () {
      const setting = Setting(
        themeMode: ThemeMode.system,
        textScaleFactor: TextScaleFactor.small,
      );

      expect(setting.toMap(), <String, dynamic>{
        'themeMode': 0,
        'textScaleFactor': 0,
      });
    });

    test('round-trips through fromMap', () {
      const setting = Setting(
        themeMode: ThemeMode.light,
        textScaleFactor: TextScaleFactor.large,
      );

      expect(Setting.fromMap(setting.toMap()), setting);
    });
  });

  group('Setting.copyWith', () {
    test('replaces only the given fields', () {
      const setting = Setting();
      final copied = setting.copyWith(themeMode: ThemeMode.light);

      expect(copied.themeMode, ThemeMode.light);
      expect(copied.textScaleFactor, TextScaleFactor.medium);
    });

    test('keeps every field when called without arguments', () {
      const setting = Setting(
        themeMode: ThemeMode.system,
        textScaleFactor: TextScaleFactor.large,
      );

      expect(setting.copyWith(), setting);
    });
  });

  group('TextScaleFactor presentation', () {
    test('toName maps to labels', () {
      expect(TextScaleFactor.small.toName(), 'Small');
      expect(TextScaleFactor.medium.toName(), 'Medium');
      expect(TextScaleFactor.large.toName(), 'Large');
    });

    test('toScaleFactor maps to multipliers', () {
      expect(TextScaleFactor.small.toScaleFactor(), 0.8);
      expect(TextScaleFactor.medium.toScaleFactor(), 1);
      expect(TextScaleFactor.large.toScaleFactor(), 1.2);
    });
  });
}
