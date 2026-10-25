import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/mobile/chat_view/bloc/chat_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/home_view.dart';
import 'package:everydaybible/platform/mobile/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

/// Root widget of the mobile app: loads settings and, once ready,
/// builds the themed app shell with all view blocs.
class App extends StatelessWidget {
  /// Creates the app root widget.
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()
        ..add(
          const SettingEventInited(),
        ),
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case SettingViewStatus.init:
            case SettingViewStatus.loading:
              // forui widgets need an FTheme ancestor even while loading.
              return FTheme(
                data: FTheme.neutral.light.touch,
                child: const BibleLoading(),
              );
            case SettingViewStatus.failure:
            case SettingViewStatus.success:
          }
          final setting = state.setting;
          // The forui design tokens follow the user's theme mode so that
          // forui widgets and the Material shell stay in the same brightness.
          final brightness = switch (setting.themeMode) {
            ThemeMode.light => Brightness.light,
            ThemeMode.dark => Brightness.dark,
            ThemeMode.system =>
              WidgetsBinding.instance.platformDispatcher.platformBrightness,
          };
          return FTheme(
            data: brightness == Brightness.dark
                ? FTheme.neutral.dark.touch
                : FTheme.neutral.light.touch,
            child: MaterialApp(
              title: 'Everyday Bible',
              debugShowCheckedModeBanner: false,
              themeMode: setting.themeMode,
              // The Material shell theme only styles residual Material pieces
              // (text selection toolbar, page transitions, default text);
              // every visible widget is themed by the forui [FTheme] above.
              darkTheme: ThemeData.dark(),
              theme: ThemeData.light(),
              home: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => HomeBloc(),
                  ),
                  BlocProvider(
                    create: (_) => BibleBloc(Repo.of(context)),
                  ),
                  BlocProvider(
                    create: (_) => ChatBloc(
                      Repo.of(context),
                      Repo.of(context),
                    ),
                  ),
                  BlocProvider(
                    create: (_) => QuiteTimeDashBoardBloc(Repo.of(context)),
                  ),
                  BlocProvider(
                    create: (_) => AudioPlayerBloc(Repo.of(context)),
                  ),
                  BlocProvider(
                    create: (_) => MemoBloc(Repo.of(context)),
                  ),
                ],
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      setting.textScaleFactor.toScaleFactor(),
                    ),
                  ),
                  child: const HomeView(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
