import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quite_time_event.dart';
part 'quite_time_state.dart';

class QuiteTimeBloc extends Bloc<QuiteTimeEvent, QuiteTimeState> {
  QuiteTimeBloc() : super(const QuiteTimeState()) {}
}
