import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/model/update/app_release.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/update_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/setting_view.dart';
import 'package:everydaybible/repo/apk_install_repo/apk_install_repo.dart';
import 'package:everydaybible/repo/update_repo/update_repo.dart';
import 'package:everydaybible/use_case/update_use_case/update_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockUpdateRepo extends Mock implements UpdateRepo {}

class _MockApkInstallRepo extends Mock implements ApkInstallRepo {}

void main() {
  Future<SettingBloc> pumpView(WidgetTester tester) async {
    final bloc = SettingBloc()..add(const SettingEventInited());
    final updateRepo = _MockUpdateRepo();
    final apkRepo = _MockApkInstallRepo();
    when(updateRepo.getLatestRelease).thenAnswer(
      (_) async => const Right(
        AppRelease(
          version: '3.0.0',
          htmlUrl: 'https://github.com/dev-hann/everyday_bible',
        ),
      ),
    );
    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MaterialApp(
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UpdateRepo>.value(value: updateRepo),
              RepositoryProvider<ApkInstallRepo>.value(value: apkRepo),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SettingBloc>.value(value: bloc),
                BlocProvider<UpdateBloc>(
                  create: (_) => UpdateBloc(
                    useCase: UpdateUseCase(updateRepo, apkRepo),
                    resolveCurrentVersion: () async => '3.0.0',
                  ),
                ),
              ],
              child: const SettingView(),
            ),
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

  testWidgets('renders the version section with the installed version', (
    tester,
  ) async {
    await pumpView(tester);

    expect(find.text('버전'), findsOneWidget);
    expect(find.textContaining('v3.0.0'), findsWidgets);
    expect(find.textContaining('최신 버전'), findsOneWidget);
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
