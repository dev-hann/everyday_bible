part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeEventInited extends HomeEvent {}

class HomeEventUpdatedIndex extends HomeEvent {
  const HomeEventUpdatedIndex(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}
