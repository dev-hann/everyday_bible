import 'package:everydaybible/firebase_options.dart';
import 'package:everydaybible/platform/mobile/main.dart' as mobile;
import 'package:everydaybible/repo/apk_install_repo/apk_install_repo.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/repo/update_repo/update_repo.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  if (kDebugMode) {
    enableFlutterDriverExtension();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleDeviceCheckProvider(),
  );
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BibleRepo>(create: (_) => BibleImpl()),
        RepositoryProvider<QuiteTimeRepo>(create: (_) => QuiteTimeImpl()),
        RepositoryProvider<AudioRepo>(create: (_) => AudioImpl()),
        RepositoryProvider<SettingRepo>(create: (_) => SettingImpl()),
        RepositoryProvider<MemoRepo>(create: (_) => MemoImpl()),
        RepositoryProvider<ChatRepo>(create: (_) => ChatImpl()),
        RepositoryProvider<UpdateRepo>(create: (_) => UpdateImpl()),
        RepositoryProvider<ApkInstallRepo>(create: (_) => ApkInstallImpl()),
      ],
      child: const mobile.App(),
    ),
  );
}
