import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  Future<SettingBloc> pumpView(WidgetTester tester) async {
    final bloc = SettingBloc()..add(const SettingEventInited());
    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MaterialApp(
          home: BlocProvider<SettingBloc>.value(
            value: bloc,
            child: const SettingView(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return bloc;
  }

  testWidgets('renders the theme switch and the text factor select', (
    tester,
  ) async {
    await pumpView(tester);

    expect(find.text('Setting'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.byType(FSwitch), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is FSelect<TextScaleFactor>),
      findsOneWidget,
    );
    expect(tester.widget<FSwitch>(find.byType(FSwitch)).value, isFalse);
  });

  testWidgets('tapping the theme switch flips the theme mode setting', (
    tester,
  ) async {
    final bloc = await pumpView(tester);

    // forui's FSwitch wraps a CupertinoSwitch; tap its track directly.
    Future<void> toggle() async {
      final track = find.descendant(
        of: find.byType(FSwitch),
        matching: find.byWidgetPredicate(
          (w) => w.runtimeType.toString() == 'CupertinoSwitch',
        ),
      );
      await tester.tapAt(tester.getRect(track).center);
      await tester.pump();
    }

    await toggle();
    expect(bloc.state.setting.themeMode, ThemeMode.light);

    await toggle();
    expect(bloc.state.setting.themeMode, ThemeMode.dark);
  });

  testWidgets('selecting a text factor updates the setting', (tester) async {
    final bloc = await pumpView(tester);

    await tester.tap(
      find.byWidgetPredicate((w) => w is FSelect<TextScaleFactor>),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('large').last);
    await tester.pumpAndSettle();

    expect(bloc.state.setting.textScaleFactor, TextScaleFactor.large);
  });
}
