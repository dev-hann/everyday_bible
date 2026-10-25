import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/model/chat/chat_message.dart';
import 'package:everydaybible/model/chat/chat_session.dart';
import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/bible_view/bible_view.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/mobile/chat_view/bloc/chat_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/mobile/home_view/home_view.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/quite_time_dash_board_view.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/chat_repo/chat_repo.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:just_audio/just_audio.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  testWidgets(
    'bottom navigation renders four tabs and switching updates the index',
    (tester) async {
      final bibleRepo = _FakeBibleRepo();
      final homeBloc = HomeBloc();
      final bibleBloc = BibleBloc(bibleRepo);
      final chatBloc = ChatBloc(_FakeChatRepo(), bibleRepo);
      final quiteTimeBloc = QuiteTimeDashBoardBloc(_FakeQuiteTimeRepo());
      final audioBloc = AudioPlayerBloc(_FakeAudioRepo());
      final settingBloc = SettingBloc()..add(const SettingEventInited());

      await tester.pumpWidget(
        FTheme(
          data: FTheme.neutral.light.touch,
          child: MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider<HomeBloc>.value(value: homeBloc),
                BlocProvider<ChatBloc>.value(value: chatBloc),
                BlocProvider<BibleBloc>.value(value: bibleBloc),
                BlocProvider<QuiteTimeDashBoardBloc>.value(
                  value: quiteTimeBloc,
                ),
                BlocProvider<AudioPlayerBloc>.value(value: audioBloc),
                BlocProvider<SettingBloc>.value(value: settingBloc),
              ],
              child: const HomeView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FBottomNavigationBar), findsOneWidget);
      expect(find.text('AI'), findsOneWidget);
      expect(find.text('Bible'), findsOneWidget);
      expect(find.text('QuiteTime'), findsOneWidget);
      expect(find.text('Setting'), findsOneWidget);
      expect(homeBloc.state.menuIndex, 0);

      await tester.tap(find.text('Bible'));
      await tester.pumpAndSettle();
      expect(homeBloc.state.menuIndex, 1);
      expect(find.byType(BibleView), findsOneWidget);
      expect(find.text('창세기 1장'), findsOneWidget);

      await tester.tap(find.text('QuiteTime'));
      await tester.pumpAndSettle();
      expect(homeBloc.state.menuIndex, 2);
      expect(find.byType(TableCalendar<Object?>), findsOneWidget);
      expect(find.byType(QuiteTimeDashBoardView), findsOneWidget);

      await tester.tap(find.text('Setting'));
      await tester.pumpAndSettle();
      expect(homeBloc.state.menuIndex, 3);
      expect(find.byType(FSwitch), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is FSelect<TextScaleFactor>),
        findsOneWidget,
      );
    },
  );
}

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
              'verseList': <String>[
                '태초에 하나님이 천지를 창조하시니라',
                '땅이 혼돈하고 공허하며',
              ],
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
      'Base_de': _format(dateTime),
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

  String _format(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-'
        '${twoDigits(dateTime.day)}';
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
