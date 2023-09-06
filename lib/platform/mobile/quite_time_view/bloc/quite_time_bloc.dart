import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/quite_time_use_case/quite_time_use_case.dart';

part 'quite_time_event.dart';
part 'quite_time_state.dart';

class QuiteTimeBloc extends Bloc<QuiteTimeEvent, QuiteTimeState> {
  QuiteTimeBloc(QuiteTimeRepo repo)
      : useCase = QuiteTimeUseCase(repo),
        super(QuiteTimeState()) {
    on<QuiteTimeEventInited>(_onInited);
    on<QuiteTimeEventChangedDateTime>(_onChangedDateTime);
  }

  final QuiteTimeUseCase useCase;

  FutureOr<void> _onInited(
      QuiteTimeEventInited event, Emitter<QuiteTimeState> emit) {
    emit(
      state.copyWith(
        status: QuiteTimeViewStatus.success,
      ),
    );
    add(
      QuiteTimeEventChangedDateTime(state.selectedDateTime),
    );
  }

  FutureOr<void> _onChangedDateTime(
      QuiteTimeEventChangedDateTime event, Emitter<QuiteTimeState> emit) async {
    emit(
      state.copyWith(
        selectedDateTime: event.dateTime,
      ),
    );
    final list = state.dataList;
    for (final item in list) {
      if (item.isSameDateTime(event.dateTime)) {
        return;
      }
    }
    final either = await useCase.requestQuiteTimeData(event.dateTime);
    either.fold(
      (fail) {},
      (data) {
        emit(
          state.copyWith(
            dataList: [...list, data],
          ),
        );
      },
    );
  }
}
