import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/quite_time_use_case/quite_time_use_case.dart';

part 'quite_time_dash_board_event.dart';
part 'quite_time_dash_board_state.dart';

class QuiteTimeDashBoardBloc
    extends Bloc<QuiteTimeDashBoardEvent, QuiteTimeDashBoardState> {
  QuiteTimeDashBoardBloc(QuiteTimeRepo repo)
      : useCase = QuiteTimeUseCase(repo),
        super(QuiteTimeDashBoardState()) {
    on<QuiteTimeDashBoardEventInited>(_onInited);
    on<QuiteTimeDashBoardEventChangedDateTime>(_onChangedDateTime);
  }

  final QuiteTimeUseCase useCase;

  FutureOr<void> _onInited(QuiteTimeDashBoardEventInited event,
      Emitter<QuiteTimeDashBoardState> emit) {
    emit(
      state.copyWith(
        status: QuiteTimeDashBoardViewStatus.success,
      ),
    );
    add(
      QuiteTimeDashBoardEventChangedDateTime(state.selectedDateTime),
    );
  }

  FutureOr<void> _onChangedDateTime(
      QuiteTimeDashBoardEventChangedDateTime event,
      Emitter<QuiteTimeDashBoardState> emit) async {
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
