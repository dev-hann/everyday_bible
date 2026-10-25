import 'package:everydaybible/platform/mobile/main.dart' as mobile;

import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots to loading state', (tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BibleRepo>(create: (_) => BibleImpl()),
          RepositoryProvider<QuiteTimeRepo>(create: (_) => QuiteTimeImpl()),
          RepositoryProvider<AudioRepo>(create: (_) => AudioImpl()),
          RepositoryProvider<SettingRepo>(create: (_) => SettingImpl()),
          RepositoryProvider<MemoRepo>(create: (_) => MemoImpl()),
        ],
        child: const mobile.App(),
      ),
    );

    await tester.pump();

    expect(find.byType(BibleLoading), findsOneWidget);
  });
}
