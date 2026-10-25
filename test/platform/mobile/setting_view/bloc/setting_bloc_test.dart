import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingBloc', () {
    test('Inited marks the view ready keeping the default settings', () async {
      final bloc = SettingBloc();
      final initial = bloc.state;
      final states = <SettingState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const SettingEventInited());
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(
          <SettingState>[
            initial.copyWith(status: SettingViewStatus.success),
          ],
        ),
      );
      expect(states.last.setting, equals(const Setting()));
    });

    test('UpdatedSetting applies the given settings', () async {
      const setting = Setting(
        themeMode: ThemeMode.light,
        textScaleFactor: TextScaleFactor.large,
      );

      final bloc = SettingBloc();
      final initial = bloc.state;
      final states = <SettingState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const SettingEventUpdatedSetting(setting));
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(<SettingState>[initial.copyWith(setting: setting)]),
      );
    });
  });
}
