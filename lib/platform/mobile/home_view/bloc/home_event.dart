part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeEventInited extends HomeEvent {}

class HomeEventUpdatedMenu extends HomeEvent {
  const HomeEventUpdatedMenu(this.type);
  final MobileMenuType type;
  @override
  List<Object> get props => [type];
}
