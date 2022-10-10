part of home_bloc;

abstract class HomeEvent extends Equatable {}

class HomeInited extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeOnTapPane extends HomeEvent {
  HomeOnTapPane(this.paneIndex);
  final int paneIndex;

  @override
  List<Object?> get props => [paneIndex];
}
