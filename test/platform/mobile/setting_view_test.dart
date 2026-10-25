import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<SettingBloc> pumpView(WidgetTester tester) async {
    final bloc = SettingBloc()..add(const SettingEventInited());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingBloc>.value(
          value: bloc,
          child: const SettingView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return bloc;
  }

  testWidgets('renders the theme switch and the text factor dropdown', (
    tester,
  ) async {
    await pumpView(tester);

    expect(find.text('Setting'), findsOneWidget);
    expect(find.text('Theme :'), findsOneWidget);
    expect(find.text('TextFactor: '), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(DropdownMenu<TextScaleFactor>), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
  });

  testWidgets('tapping the theme switch flips the theme mode setting', (
    tester,
  ) async {
    final bloc = await pumpView(tester);

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(bloc.state.setting.themeMode, ThemeMode.light);

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(bloc.state.setting.themeMode, ThemeMode.dark);
  });

  testWidgets('selecting a text factor updates the setting', (tester) async {
    final bloc = await pumpView(tester);

    await tester.tap(find.byType(DropdownMenu<TextScaleFactor>));
    await tester.pumpAndSettle();
    // The selected label and the menu entry both show 'large'; the menu
    // entry is the later widget in tree order.
    await tester.tap(find.text('large').last);
    await tester.pumpAndSettle();

    expect(bloc.state.setting.textScaleFactor, TextScaleFactor.large);
  });
}
