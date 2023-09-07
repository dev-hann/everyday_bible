import 'package:everydaybible/enum/text_scale_factor.dart';
import 'package:everydaybible/platform/desktop/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/desktop/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/desktop/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/desktop/home_view/home_view.dart';
import 'package:everydaybible/platform/desktop/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/platform/desktop/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/platform/desktop/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingBloc()..add(SettingEventInited()),
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
          return FluentApp(
            title: "Everyday Bible",
            debugShowCheckedModeBanner: false,
            themeMode: setting.themeMode,
            theme: FluentThemeData.light(),
            darkTheme: FluentThemeData.dark(),
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => HomeBloc(),
                ),
                BlocProvider(
                  create: (_) => QuiteTimeBloc(Repo.of(context))
                    ..add(const QuiteTimeEventInited()),
                ),
                BlocProvider(
                  create: (_) => BibleBloc(Repo.of(context))
                    ..add(const BibleEventInited()),
                ),
                BlocProvider(
                  create: (_) => AudioPlayerBloc(Repo.of(context))
                    ..add(const AudioPlayerEventInited()),
                ),
                BlocProvider(
                  create: (_) =>
                      MemoBloc(Repo.of(context))..add(const MemoEventInited()),
                ),
              ],
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: setting.textScaleFactor.toScaleFactor(),
                ),
                child: const HomeView(),
              ),
            ),
          );
        },
      ),
    );
  }
}
