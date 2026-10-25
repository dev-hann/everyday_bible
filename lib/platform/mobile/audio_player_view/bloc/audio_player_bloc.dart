import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/use_case/audio_use_case/audio_use_case.dart';
import 'package:intl/intl.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

/// Loads and controls the meditation audio of the selected date: playback,
/// pause, seek, and volume.
class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  /// Creates the bloc backed by [repo].
  AudioPlayerBloc(AudioRepo repo)
      : useCase = AudioUseCase(repo),
        super(AudioPlayerState()) {
    on<AudioPlayerEventInited>(_onInited);
    on<AudioPlayerEventLoadedAudio>(_onLoadedAudio);
    on<AudioPlayerEventSeekPosition>(onSeekPosition);
    on<AudioPlayerEventChangedVolume>(_onChangedVolume);
    on<AudioPlayerEventPlayed>(_onPlayed);
    on<AudioPlayerEventPaused>(_onPaused);
  }

  /// Use case wrapping the audio repository.
  final AudioUseCase useCase;

  FutureOr<void> _onInited(
    AudioPlayerEventInited event,
    Emitter<AudioPlayerState> emit,
  ) async {
    final audioState = state.audioState;
    if (audioState.url.isNotEmpty) {
      await useCase.stopAudio();
    }
    emit(
      state.copyWith(
        status: AudioPlayerViewStatus.init,
        dateTime: event.dateTime,
        audioState: const AudioState(),
      ),
    );
    add(AudioPlayerEventLoadedAudio());
    await emit.onEach(
      useCase.stateStream(),
      onData: (audioState) {
        emit(
          state.copyWith(
            audioState: audioState,
          ),
        );
      },
    );
  }

  FutureOr<void> _onLoadedAudio(
    AudioPlayerEventLoadedAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AudioPlayerViewStatus.loading,
      ),
    );
    await useCase.loadAudio(state.audioURL);
    emit(
      state.copyWith(
        status: AudioPlayerViewStatus.success,
      ),
    );
  }

  /// Seeks playback to the position of [event].
  FutureOr<void> onSeekPosition(
    AudioPlayerEventSeekPosition event,
    Emitter<AudioPlayerState> emit,
  ) {
    unawaited(useCase.seekAudio(event.duration));
  }

  FutureOr<void> _onChangedVolume(
    AudioPlayerEventChangedVolume event,
    Emitter<AudioPlayerState> emit,
  ) {
    unawaited(useCase.setVolume(event.volume));
  }

  FutureOr<void> _onPlayed(
    AudioPlayerEventPlayed event,
    Emitter<AudioPlayerState> emit,
  ) {
    unawaited(useCase.playAudio());
  }

  FutureOr<void> _onPaused(
    AudioPlayerEventPaused event,
    Emitter<AudioPlayerState> emit,
  ) {
    unawaited(useCase.pauseAudio());
  }
}
