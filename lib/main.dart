import 'package:everydaybible/data_base/data/box.dart';
import 'package:everydaybible/enum/text_scale_factor.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/qt_repo/qt_repo.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/views/intro_view/intro_view.dart';
import 'package:everydaybible/views/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await LocalBox.init();
  final settingRepo = SettingImpl();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BibleRepo>(create: (_) => BibleImpl()),
        RepositoryProvider<QTRepo>(create: (_) => QTImpl()),
        RepositoryProvider<AudioRepo>(create: (_) => AudioImpl()),
        RepositoryProvider<SettingRepo>(create: (_) => settingRepo),
      ],
      child: BlocProvider(
        create: (_) => SettingBloc(settingRepo)..add(SettingInited()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final status = state.status;
        final setting = state.setting;
        switch (status) {
          case SettingViewStatus.init:
            return const BibleLoading();
          case SettingViewStatus.loading:
          case SettingViewStatus.fail:
          case SettingViewStatus.success:
        }
        return FluentApp(
          title: "Everyday Bible",
          debugShowCheckedModeBanner: false,
          themeMode: setting.themeMode,
          darkTheme: ThemeData.dark(),
          home: const IntroView(),
        );
      },
    );
  }
}
