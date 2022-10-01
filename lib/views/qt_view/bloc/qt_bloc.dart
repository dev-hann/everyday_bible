library qt_bloc;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/quite_time.dart';
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
  }

  final QTUseCase qtUseCase;

  FutureOr<void> _onInit(QTOnInited event, Emitter<QTState> emit) async {
    final now = QuiteTimeFormat(DateTime.now());
    final qt = await qtUseCase.requestQT(now);
    emit(
      state.copy(
        status: QTViewStatus.success,
        dateTime: now,
        qtDataMap: {now.toString(): qt},
      ),
    );
  }
}
