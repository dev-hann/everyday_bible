part of 'home_bloc.dart';

enum HomeViewStatus {
  init,
  loading,
  failure,
  success,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeViewStatus.init,
    this.menuIndex = 0,
  });
  final HomeViewStatus status;
  final int menuIndex;

  @override
  List<Object> get props => [
        status,
        menuIndex,
      ];

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
