import 'package:everydaybible/platform/desktop/main.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // await LocalBox.init();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BibleRepo>(create: (_) => BibleImpl()),
        RepositoryProvider<QuiteTimeRepo>(create: (_) => QuiteTimeImpl()),
        RepositoryProvider<AudioRepo>(create: (_) => AudioImpl()),
        RepositoryProvider<SettingRepo>(create: (_) => SettingImpl()),
      ],
      child: const MyApp(),
    ),
  );
}
