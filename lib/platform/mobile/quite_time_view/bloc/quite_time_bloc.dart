import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:everydaybible/use_case/quite_time_use_case/quite_time_use_case.dart';

part 'quite_time_event.dart';
part 'quite_time_state.dart';

class QuiteTimeBloc extends Bloc<QuiteTimeEvent, QuiteTimeState> {
  QuiteTimeBloc(QuiteTimeRepo repo)
      : useCase = QuiteTimeUseCase(repo),
        super(QuiteTimeInitial()) {}

  final QuiteTimeUseCase useCase;
}
