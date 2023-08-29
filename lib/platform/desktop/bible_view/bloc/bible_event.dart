part of 'bible_bloc.dart';

abstract class BibleEvent extends Equatable {
  const BibleEvent();

  @override
  List<Object> get props => [];
}

class BibleEventInited extends BibleEvent {}
