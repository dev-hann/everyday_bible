import 'dart:async';

import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAudioRepo extends Mock implements AudioRepo {}

void main() {
  group('AudioPlayerBloc', () {
    late _MockAudioRepo repo;

    setUp(() {
      repo = _MockAudioRepo();
    });

    final day = DateTime(2026, 1, 2, 8);
    final otherDay = DateTime(2026, 3, 5, 20);
    const dayURL =
        'https://meditation.su.or.kr/meditation_mp3/2026/20260102.mp3';
    const otherDayURL =
        'https://meditation.su.or.kr/meditation_mp3/2026/20260305.mp3';

    test('Inited resets the state, loads the audio, and follows playback',
        () async {
      final controller = StreamController<AudioState>.broadcast();
      when(() => repo.stateStream()).thenAnswer((_) => controller.stream);
      when(() => repo.loadAudio(any<String>())).thenAnswer((_) async {});

      final bloc = AudioPlayerBloc(repo);
      final initial = bloc.state;
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(AudioPlayerEventInited(day));
      await pumpEventQueue();
      const playing = AudioState(url: 'https://qt.mp3', playing: true);
      controller.add(playing);
      await pumpEventQueue();
      await bloc.close();
      await sub.cancel();
      await controller.close();

      final reset = initial.copyWith(dateTime: day);
      final loading = reset.copyWith(status: AudioPlayerViewStatus.loading);
      final ready = loading.copyWith(status: AudioPlayerViewStatus.success);
      expect(
        states,
        equals(
          <AudioPlayerState>[
            reset,
            loading,
            ready,
            ready.copyWith(audioState: playing),
          ],
        ),
      );
      verify(() => repo.loadAudio(dayURL)).called(1);
      verifyNever(() => repo.stopAudio());
    });

    test('LoadedAudio reports loading then success for the current URL',
        () async {
      when(() => repo.loadAudio(any<String>())).thenAnswer((_) async {});

      final bloc = AudioPlayerBloc(repo);
      final initial = bloc.state;
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(AudioPlayerEventLoadedAudio());
      await bloc.close();
      await sub.cancel();

      final loading = initial.copyWith(status: AudioPlayerViewStatus.loading);
      expect(
        states,
        equals(
          <AudioPlayerState>[
            loading,
            loading.copyWith(status: AudioPlayerViewStatus.success),
          ],
        ),
      );
      verify(() => repo.loadAudio(any<String>())).called(1);
    });

    test('Inited stops the previous audio before loading the new date',
        () async {
      final controller = StreamController<AudioState>.broadcast();
      when(() => repo.stateStream()).thenAnswer((_) => controller.stream);
      when(() => repo.loadAudio(any<String>())).thenAnswer((_) async {});
      when(() => repo.stopAudio()).thenAnswer((_) async {});

      final bloc = AudioPlayerBloc(repo);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(AudioPlayerEventInited(day));
      await pumpEventQueue();
      const oldSource = AudioState(url: 'https://old.mp3', playing: true);
      controller.add(oldSource);
      await pumpEventQueue();
      bloc.add(AudioPlayerEventInited(otherDay));
      await pumpEventQueue();
      await bloc.close();
      await sub.cancel();
      await controller.close();

      expect(states.last.dateTime, otherDay);
      verify(() => repo.stopAudio()).called(1);
      verify(() => repo.loadAudio(otherDayURL)).called(1);
    });

    test('play, pause, seek, and volume events only drive the repo', () async {
      when(() => repo.playAudio()).thenAnswer((_) async {});
      when(() => repo.pauseAudio()).thenAnswer((_) async {});
      when(() => repo.seekAudio(const Duration(seconds: 30)))
          .thenAnswer((_) async {});
      when(() => repo.setVolume(0.5)).thenAnswer((_) async {});

      final bloc = AudioPlayerBloc(repo);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc
        ..add(AudioPlayerEventPlayed())
        ..add(AudioPlayerEventPaused())
        ..add(const AudioPlayerEventSeekPosition(Duration(seconds: 30)))
        ..add(const AudioPlayerEventChangedVolume(0.5));
      await bloc.close();
      await sub.cancel();

      expect(states, isEmpty);
      verify(() => repo.playAudio()).called(1);
      verify(() => repo.pauseAudio()).called(1);
      verify(() => repo.seekAudio(const Duration(seconds: 30))).called(1);
      verify(() => repo.setVolume(0.5)).called(1);
    });
  });
}
