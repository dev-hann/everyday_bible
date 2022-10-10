part of bible_bloc;

abstract class BibleEvent extends Equatable {}

class BibleInited extends BibleEvent {
  @override
  List<Object?> get props => [];
}

class BibleOnTapTab extends BibleEvent {
  BibleOnTapTab(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}
