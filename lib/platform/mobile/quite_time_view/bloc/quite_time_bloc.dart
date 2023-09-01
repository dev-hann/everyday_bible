import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/models/quite_time/quite_time.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/quite_time_use_case/quite_time_use_case.dart';

part 'quite_time_event.dart';
part 'quite_time_state.dart';

class QuiteTimeBloc extends Bloc<QuiteTimeEvent, QuiteTimeState> {
  QuiteTimeBloc(QuiteTimeRepo repo)
      : useCase = QuiteTimeUseCase(repo),
        super(QuiteTimeState()) {
    on<QuiteTimeEventInited>(_onInited);
    on<QuiteTimeEventUpdatedDateTime>(_onUpdatedDateTime);
  }
  final QuiteTimeUseCase useCase;

  FutureOr<void> _onInited(
      QuiteTimeEventInited event, Emitter<QuiteTimeState> emit) {
    add(QuiteTimeEventUpdatedDateTime(DateTime.now()));
  }

  FutureOr<void> _onUpdatedDateTime(
      QuiteTimeEventUpdatedDateTime event, Emitter<QuiteTimeState> emit) async {
    final dateTime = event.dateTime;
    emit(
      state.copyWith(
        status: QuiteTimeViewStatus.loading,
        dateTime: dateTime,
      ),
    );
    final either = await useCase.requestQuiteTime(dateTime);
    either.fold(
      (fail) {},
      (data) {
        emit(
          state.copyWith(
            status: QuiteTimeViewStatus.success,
            quiteTime: data,
          ),
        );
      },
    );
  }
}
