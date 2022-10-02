library qt_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/quite_time.dart';
import 'package:everydaybible/models/quite_time_audio.dart';
import 'package:everydaybible/models/quite_time_format.dart';
import 'package:everydaybible/repo/qt_repo/qt_repo.dart';
import 'package:everydaybible/use_case/qt_use_case/qt_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qt_state.dart';
part 'qt_event.dart';

class QTBloc extends Bloc<QTEvent, QTState> {
  QTBloc(
    QTRepo qtRepo,
  )   : qtUseCase = QTUseCase(qtRepo),
        super(const QTState()) {
    on<QTOnInited>(_onInit);
    on<QTOnTapPlay>(_onTapPlay);
    on<QTOnChangedDuration>(_onChangedDuration);
  }

  final QTUseCase qtUseCase;

  FutureOr<void> _onInit(QTOnInited event, Emitter<QTState> emit) async {
    final now = QuiteTimeFormat(DateTime.now());
    final qt = await qtUseCase.requestQT(now);
    emit(
      state.copyWith(
        status: QTViewStatus.success,
        dateTime: now,
        qtDataMap: {now.toString(): qt},
        audio: QuiteTimeAudio(
          title: qt.title,
          totalDuration: Duration(
            minutes: 1,
            seconds: 30,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onTapPlay(QTOnTapPlay event, Emitter<QTState> emit) {
    final audio = state.audio;
    emit(
      state.copyWith(
        audio: audio.copyWith(
          isPlaying: !audio.isPlaying,
        ),
      ),
    );
  }

  FutureOr<void> _onChangedDuration(
      QTOnChangedDuration event, Emitter<QTState> emit) {
    final value = event.value;
    final audio = state.audio;
    emit(
      state.copyWith(
        audio: audio.copyWith(
          currentDuration: Duration(milliseconds: value.toInt()),
        ),
      ),
    );
  }
}
