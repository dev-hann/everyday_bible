import 'package:everydaybible/enum/text_scale_factor.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/home_view.dart';
import 'package:everydaybible/platform/mobile/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(SettingEventInited()),
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case SettingViewStatus.init:
            case SettingViewStatus.loading:
              return const BibleLoading();
            case SettingViewStatus.failure:
            case SettingViewStatus.success:
          }
          final setting = state.setting;
          return MaterialApp(
            title: "Everyday Bible",
            debugShowCheckedModeBanner: false,
            themeMode: setting.themeMode,
            darkTheme: ThemeData.dark().copyWith(
              useMaterial3: true,
              typography: Typography.material2021(
                colorScheme: const ColorScheme.dark(),
                black: const TextTheme().apply(
                  fontSizeFactor: setting.textScaleFactor.toScaleFactor(),
                ),
                white: const TextTheme().apply(
                  fontSizeFactor: setting.textScaleFactor.toScaleFactor(),
                ),
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                scrolledUnderElevation: 0.0,
              ),
              cardTheme: const CardTheme(
                margin: EdgeInsets.zero,
              ),
            ),
            theme: ThemeData(
              useMaterial3: true,
              typography: Typography.material2021(
                colorScheme: const ColorScheme.light(),
                black: const TextTheme().apply(
                  fontSizeFactor: setting.textScaleFactor.toScaleFactor(),
                ),
                white: const TextTheme().apply(
                  fontSizeFactor: setting.textScaleFactor.toScaleFactor(),
                ),
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                scrolledUnderElevation: 0.0,
              ),
              cardTheme: const CardTheme(
                margin: EdgeInsets.zero,
              ),
            ),
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => HomeBloc(),
                ),
                BlocProvider(
                  create: (_) => BibleBloc(Repo.of(context))
                    ..add(
                      const BibleEventInited(),
                    ),
                ),
                BlocProvider(
                  create: (_) => QuiteTimeBloc(Repo.of(context))
                    ..add(
                      const QuiteTimeEventInited(),
                    ),
                ),
                BlocProvider(
                  create: (_) => AudioPlayerBloc(Repo.of(context))
                    ..add(
                      const AudioPlayerEventInited(),
                    ),
                ),
                BlocProvider(
                  create: (_) => MemoBloc(Repo.of(context))
                    ..add(
                      const MemoEventInited(),
                    ),
                ),
              ],
              child: const HomeView(),
            ),
          );
        },
      ),
    );
  }
}
