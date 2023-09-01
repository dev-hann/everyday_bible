part of 'bible_bloc.dart';

abstract class BibleEvent extends Equatable {
  const BibleEvent();

  @override
  List<Object> get props => [];
}

class BibleEventInited extends BibleEvent {
  const BibleEventInited();
}

class BibleEventUpdatedChapter extends BibleEvent {
  const BibleEventUpdatedChapter(this.chapter);
  final BibleChapter chapter;
  @override
  List<Object> get props => [chapter];
}
