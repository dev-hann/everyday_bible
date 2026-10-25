part of 'home_bloc.dart';

/// Base class for home screen events.
abstract class HomeEvent extends Equatable {
  /// Creates a base home screen event.
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Marks the home screen as ready.
class HomeEventInited extends HomeEvent {
  /// Creates an init event.
  const HomeEventInited();
}

/// Switches the bottom navigation bar to a new tab.
class HomeEventUpdatedIndex extends HomeEvent {
  /// Creates an event selecting the tab at [index].
  const HomeEventUpdatedIndex(this.index);

  /// The tab index to show.
  final int index;

  @override
  List<Object> get props => [index];
}
