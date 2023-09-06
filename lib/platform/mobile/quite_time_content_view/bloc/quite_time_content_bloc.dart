import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/quite_time/quite_time.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/quite_time_use_case/quite_time_use_case.dart';

part 'quite_time_content_event.dart';
part 'quite_time_content_state.dart';

class QuiteTimeContentBloc
    extends Bloc<QuiteTimeContentEvent, QuiteTimeContentState> {
  QuiteTimeContentBloc(QuiteTimeRepo repo)
      : useCase = QuiteTimeUseCase(repo),
        super(QuiteTimeContentState()) {
    on<QuiteTimeContentEventInited>(_onInited);
    on<QuiteTimeContentEventUpdatedDateTime>(_onUpdatedDateTime);
  }
  final QuiteTimeUseCase useCase;

  FutureOr<void> _onInited(
      QuiteTimeContentEventInited event, Emitter<QuiteTimeContentState> emit) {
    add(
      QuiteTimeContentEventUpdatedDateTime(event.dateTime),
    );
  }

  FutureOr<void> _onUpdatedDateTime(QuiteTimeContentEventUpdatedDateTime event,
      Emitter<QuiteTimeContentState> emit) async {
    final dateTime = event.dateTime;
    emit(
      state.copyWith(
        status: QuiteTimeContentViewStatus.loading,
        dateTime: dateTime,
      ),
    );
    final either = await useCase.requestQuiteTime(dateTime);
    either.fold(
      (fail) {},
      (data) {
        emit(
          state.copyWith(
            status: QuiteTimeContentViewStatus.success,
            quiteTime: data,
          ),
        );
      },
    );
  }
}
