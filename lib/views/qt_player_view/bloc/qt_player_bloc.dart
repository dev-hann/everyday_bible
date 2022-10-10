library qt_player_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/quite_time_duration.dart';
import 'package:everydaybible/models/quite_time_audio.dart';
import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/use_case/audio_use_case/audio_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qt_player_state.dart';
part 'qt_player_event.dart';

class QTPlayerBloc extends Bloc<QTPlayerEvent, QTPlayerState> {
  QTPlayerBloc(
    AudioRepo audioRepo,
  )   : audioUseCase = AudioUseCase(audioRepo),
        super(const QTPlayerState()) {
    on<QTPlayerInited>(_onInit);
    on<QTPlayerOnTapPlay>(_onTapPlay);
    on<QTPlayerOnChangeDurationStart>(_onChangedDurationStart);
    on<QTPlayerOnChangeDuration>(_onChangedDuration);
    on<QTPlayerOnChangeDurationEnd>(_onChangedDurationEnd);
    on<QTPlayerOnChangedVolume>(_onChangedVolume);
  }

  final AudioUseCase audioUseCase;
  FutureOr<void> _onInit(
      QTPlayerInited event, Emitter<QTPlayerState> emit) async {
    await audioUseCase.loadAudio(event.audioURL);
    emit(
      state.copyWith(
        status: QTPlayerViewStatus.success,
        audio: QuiteTimeAudio(
          title: event.title,
          url: event.audioURL,
          volume: audioUseCase.getVolume(),
        ),
      ),
    );
    await emit.forEach<QuiteTimeDuration>(
      audioUseCase.durationStream(),
      onData: (data) {
        if (state.isChangingDuration) {
          return state;
        }
        return state.copyWith(
            audio: state.audio.copyWith(
          isPlaying: data.isPlaying,
          state: data.state,
          position: data.position,
          duration: data.duration,
        ));
      },
    );
  }

  FutureOr<void> _onTapPlay(
      QTPlayerOnTapPlay event, Emitter<QTPlayerState> emit) {
    final audio = state.audio;
    final isPlaying = audio.isPlaying;
    if (isPlaying) {
      audioUseCase.pauseAudio();
    } else {
      audioUseCase.playAudio();
    }
  }

  FutureOr<void> _onChangedDurationStart(
      QTPlayerOnChangeDurationStart event, Emitter<QTPlayerState> emit) {
    emit(
      state.copyWith(
        isChangingDuration: true,
      ),
    );
  }

  FutureOr<void> _onChangedDuration(
      QTPlayerOnChangeDuration event, Emitter<QTPlayerState> emit) {
    final value = event.value;
    final duration = Duration(milliseconds: value.toInt());
    final audio = state.audio;
    emit(
      state.copyWith(
        audio: audio.copyWith(
          position: duration,
        ),
      ),
    );
  }

  FutureOr<void> _onChangedDurationEnd(
      QTPlayerOnChangeDurationEnd event, Emitter<QTPlayerState> emit) async {
    final value = event.value;
    final duration = Duration(milliseconds: value.toInt());
    await audioUseCase.seekAudio(duration);
    emit(
      state.copyWith(
        isChangingDuration: false,
      ),
    );
  }

  FutureOr<void> _onChangedVolume(
      QTPlayerOnChangedVolume event, Emitter<QTPlayerState> emit) async {
    await audioUseCase.setVolume(event.volume);
    emit(
      state.copyWith(
        audio: state.audio.copyWith(
          volume: audioUseCase.getVolume(),
        ),
      ),
    );
  }
}
