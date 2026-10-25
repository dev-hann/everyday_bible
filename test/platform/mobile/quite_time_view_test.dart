import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/quite_time_view.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  testWidgets('shows the day title, gospel verses, and the audio bar', (
    tester,
  ) async {
    final audioBloc = AudioPlayerBloc(_FakeAudioRepo());
    final data = QuiteTimeData(
      type: 'QT1',
      dateTime: DateTime(2026, 10, 25),
      bibleName: '창세기',
      chapter: '1장',
      title: '말씀을 따라 살아가는 하루',
      summary: '창세기 1장을 묵상합니다',
    );

    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<QuiteTimeRepo>.value(
              value: _FakeQuiteTimeRepo(),
            ),
          ],
          child: BlocProvider<AudioPlayerBloc>.value(
            value: audioBloc,
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  return FButton(
                    onPress: () {
                      Navigator.push(
                        context,
                        QuiteTimeView.route(context: context, data: data),
                      );
                    },
                    child: const Text('open reader'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open reader'));
    await tester.pumpAndSettle();

    expect(find.text('QuiteTimeContent'), findsOneWidget);
    expect(find.text('말씀을 따라 살아가는 하루'), findsOneWidget);
    expect(find.textContaining('태초에 하나님이 천지를 창조하시니라'), findsOneWidget);
    expect(find.byIcon(FLucideIcons.play), findsOneWidget);
  });
}

class _FakeQuiteTimeRepo extends QuiteTimeRepo {
  @override
  Future<dynamic> requestQuiteTimeData(DateTime dateTime) async {
    return <String, dynamic>{
      'Qt_ty': 'QT1',
      'Base_de': _format(dateTime),
      'Bible_name': '창세기',
      'Bible_chapter': '1장',
      'Qt_sj': '말씀을 따라 살아가는 하루',
      'Qt_Brf': '창세기 1장을 묵상합니다',
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
      <String, dynamic>{
        'Chapter': 1,
        'Verse': 2,
        'Bible_Cn': '땅이 혼돈하고 공허하며',
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
  Stream<AudioState> stateStream() {
    return Stream<AudioState>.value(
      const AudioState(
        url: 'https://example.com/qt.mp3',
        state: ProcessingState.ready,
        duration: Duration(minutes: 10),
        position: Duration(minutes: 1),
      ),
    );
  }

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
