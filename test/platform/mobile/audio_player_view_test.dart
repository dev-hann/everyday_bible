import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/audio_player_view.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  Future<_FakeAudioRepo> pumpView(
    WidgetTester tester, {
    AudioState? initialState,
  }) async {
    final repo = _FakeAudioRepo(initialState: initialState);
    final bloc = AudioPlayerBloc(repo);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AudioPlayerBloc>.value(
            value: bloc,
            child: const AudioPlayerView(),
          ),
        ),
      ),
    );
    bloc.add(AudioPlayerEventInited(DateTime(2026, 10, 25)));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    return repo;
  }

  testWidgets(
    'renders play button, seek slider, and time text when the audio is ready',
    (tester) async {
      final repo = await pumpView(tester);

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('01:00 / 10:00'), findsOneWidget);
      expect(
        repo.calls,
        contains('load:https://meditation.su.or.kr/meditation_mp3/2026/'
            '20261025.mp3'),
      );
    },
  );

  testWidgets('tapping the play button dispatches play to the repo', (
    tester,
  ) async {
    final repo = await pumpView(tester);

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    expect(repo.calls, contains('play'));
  });

  testWidgets(
    'shows a loading indicator instead of controls while buffering',
    (tester) async {
      await pumpView(
        tester,
        initialState: const AudioState(state: ProcessingState.buffering),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Slider), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    },
  );
}

class _FakeAudioRepo extends AudioRepo {
  _FakeAudioRepo({AudioState? initialState})
      : _initialState = initialState ??
            const AudioState(
              url: 'https://example.com/qt.mp3',
              state: ProcessingState.ready,
              duration: Duration(minutes: 10),
              position: Duration(minutes: 1),
            );

  final AudioState _initialState;
  final List<String> calls = <String>[];

  @override
  Stream<AudioState> stateStream() => Stream<AudioState>.value(_initialState);

  @override
  Future<void> setLoopMode(LoopMode loopMode) async {}

  @override
  Future<void> setVolume(double value) async {}

  @override
  Future<void> loadAudio(String audioURL) async {
    calls.add('load:$audioURL');
  }

  @override
  Future<void> playAudio() async {
    calls.add('play');
  }

  @override
  Future<void> pauseAudio() async {
    calls.add('pause');
  }

  @override
  Future<void> seekAudio(Duration duration) async {
    calls.add('seek:${duration.inMilliseconds}');
  }

  @override
  Future<void> stopAudio() async {
    calls.add('stop');
  }
}
