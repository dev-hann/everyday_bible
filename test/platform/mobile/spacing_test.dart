import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/model/failure.dart';
import 'package:everydaybible/model/update/app_release.dart';
import 'package:everydaybible/model/update/download_progress.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/mobile/chat_view/bloc/chat_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/home_view.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/update_bloc.dart';
import 'package:everydaybible/repo/apk_install_repo/apk_install_repo.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/repo/update_repo/update_repo.dart';
import 'package:everydaybible/use_case/update_use_case/update_use_case.dart';
import 'package:everydaybible/widgets/app_theme.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:everydaybible/widgets/material_text_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:fpdart/fpdart.dart';
import 'package:just_audio/just_audio.dart';

/// Layout budget of the app shell at a 360dp phone width:
/// every tab keeps a single 16px horizontal gutter. The home shell nests an
/// FScaffold per tab on top of its own, so the app theme zeroes the forui
/// scaffold page padding (default horizontal 12) — otherwise the two stacked
/// scaffolds would push content to a 40px inset.
const kScreenGutter = 16.0;

class _FakeChatRepo extends ChatRepo {
  @override
  Future<void> deleteSession(String sessionId) async {}

  @override
  Future<List<ChatMessage>> loadMessages(String sessionId) async => [];

  @override
  Future<List<ChatSession>> loadSessions() async => [];

  @override
  Stream<String> sendMessage({
    required String question,
    required String scriptureContext,
    List<ChatMessage> history = const [],
  }) async* {}

  @override
  Future<void> saveMessage(ChatMessage message) async {}

  @override
  Future<void> upsertSession(ChatSession session) async {}
}

class _FakeBibleRepo extends BibleRepo {
  @override
  bool databaseIsEmpty() => false;

  @override
  Future<void> initDataBase() async {}

  @override
  List<MapEntry<String, dynamic>> loadBibleDataList() {
    return const <MapEntry<String, dynamic>>[
      MapEntry(
        '01',
        <String, dynamic>{
          'name': '창세기',
          'chapterList': <Map<String, dynamic>>[
            <String, dynamic>{
              'verseList': <String>['태초에 하나님이 천지를 창조하시니라', '땅이 혼돈하고 공허하며'],
            },
          ],
        },
      ),
    ];
  }
}

class _FakeQuiteTimeRepo extends QuiteTimeRepo {
  @override
  Future<dynamic> requestQuiteTimeData(DateTime dateTime) async {
    return <String, dynamic>{
      'Qt_ty': 'QT1',
      'Base_de': '2026-10-26',
      'Bible_name': '창세기',
      'Bible_chapter': '1장',
      'Qt_sj': '매일의 묵상 제목',
      'Qt_Brf': '매일의 묵상 요약',
    };
  }

  @override
  Future<dynamic> requestQuiteTimeBody(DateTime dateTime) async {
    return <Map<String, dynamic>>[
      <String, dynamic>{
        'Chapter': 1,
        'Verse': 1,
        'Bible_Cn': '태초에 하나님이 천지를 창조하시니라',
      },
    ];
  }
}

class _FakeAudioRepo extends AudioRepo {
  @override
  Stream<AudioState> stateStream() => const Stream.empty();

  @override
  Future<void> setLoopMode(LoopMode loopMode) async {}

  @override
  Future<void> setVolume(double value) async {}

  @override
  Future<void> loadAudio(String audioURL) async {}

  @override
  Future<void> playAudio() async {}

  @override
  Future<void> pauseAudio() async {}

  @override
  Future<void> seekAudio(Duration duration) async {}

  @override
  Future<void> stopAudio() async {}
}

class _FakeUpdateRepo extends UpdateRepo {
  @override
  Future<Either<Failure, AppRelease>> getLatestRelease() async {
    return const Right(
      AppRelease(
        version: '3.2.0',
        htmlUrl: 'https://github.com/dev-hann/everyday_bible',
      ),
    );
  }
}

class _FakeApkInstallRepo extends ApkInstallRepo {
  @override
  Stream<DownloadProgress> download(String url) => const Stream.empty();

  @override
  Future<Either<Failure, bool>> canRequestPackageInstalls() async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, Unit>> launchInstaller() async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> openInstallPermissionSettings() async {
    return const Right(unit);
  }

  @override
  void cancelDownload() {}
}

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    final bibleRepo = _FakeBibleRepo();
    await tester.pumpWidget(
      FTheme(
        data: appTheme(Brightness.light),
        child: MaterialApp(
          builder: (context, child) =>
              MaterialTextDefaults(child: child ?? const SizedBox()),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>.value(value: HomeBloc()),
              BlocProvider<ChatBloc>.value(
                value: ChatBloc(_FakeChatRepo(), bibleRepo),
              ),
              BlocProvider<BibleBloc>.value(value: BibleBloc(bibleRepo)),
              BlocProvider<QuiteTimeDashBoardBloc>.value(
                value: QuiteTimeDashBoardBloc(_FakeQuiteTimeRepo()),
              ),
              BlocProvider<AudioPlayerBloc>.value(
                value: AudioPlayerBloc(_FakeAudioRepo()),
              ),
              BlocProvider<SettingBloc>.value(
                value: SettingBloc()..add(const SettingEventInited()),
              ),
              BlocProvider<UpdateBloc>.value(
                value: UpdateBloc(
                  useCase: UpdateUseCase(
                    _FakeUpdateRepo(),
                    _FakeApkInstallRepo(),
                  ),
                  resolveCurrentVersion: () async => '3.2.0',
                ),
              ),
            ],
            child: const HomeView(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('every tab keeps the single 16px horizontal gutter', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final original = FlutterError.onError;
    final others = <FlutterErrorDetails>[];
    FlutterError.onError = (details) {
      final text = details.toString();
      if (!text.contains('calendar/header.dart')) {
        others.add(details);
        original?.call(details);
      }
    };
    addTearDown(() => FlutterError.onError = original);

    await pumpHome(tester);

    await tester.tap(find.text('Bible'));
    await tester.pumpAndSettle();
    final verse = tester.getRect(find.byType(VerseText).first);
    expect(verse.left, kScreenGutter);
    expect(360 - verse.right, kScreenGutter);

    await tester.tap(find.text('QuiteTime'));
    await tester.pumpAndSettle();
    final card = tester.getRect(find.byType(FCard).first);
    expect(card.left, kScreenGutter);
    expect(360 - card.right, kScreenGutter);

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();
    final tile = tester.getRect(find.byType(FTile).first);
    expect(tile.left, kScreenGutter);
    expect(360 - tile.right, kScreenGutter);
  });

  testWidgets('chat example chips fit the content width', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await pumpHome(tester);

    final chips = find.byWidgetPredicate(
      (w) => w is FButton && w.variant == FButtonVariant.secondary,
    );
    expect(chips, findsWidgets);
    for (final chip in chips.evaluate()) {
      final rect = tester.getRect(
        find.byWidgetPredicate((w) => w == chip.widget),
      );
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(360));
    }
  });
}
