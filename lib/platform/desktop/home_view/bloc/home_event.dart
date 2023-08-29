part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeEventInited extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeEventUpdatedIndex extends HomeEvent {
  const HomeEventUpdatedIndex(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}
