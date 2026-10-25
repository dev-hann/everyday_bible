part of 'home_bloc.dart';

/// Lifecycle status of the home view.
enum HomeViewStatus {
  /// The home screen has not been initialized yet.
  init,

  /// The home screen is being prepared.
  loading,

  /// Preparing the home screen failed.
  failure,

  /// The home screen is ready.
  success,
}

/// State of the home screen: its status and the selected tab.
class HomeState extends Equatable {
  /// Creates the state showing the first tab.
  const HomeState({
    this.status = HomeViewStatus.init,
    this.menuIndex = 0,
  });

  /// Lifecycle status of the view.
  final HomeViewStatus status;

  /// Index of the tab selected in the bottom navigation bar.
  final int menuIndex;

  @override
  List<Object> get props => [
        status,
        menuIndex,
      ];

  /// Returns a copy of this state with the given fields replaced.
  HomeState copyWith({
    HomeViewStatus? status,
    int? menuIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      menuIndex: menuIndex ?? this.menuIndex,
    );
  }
}
