import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bible_event.dart';
part 'bible_state.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  BibleBloc() : super(BibleInitial()) {}
}
