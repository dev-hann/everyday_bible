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
    this.index = 1,
  });
  final HomeViewStatus status;
  final int index;

  @override
  List<Object> get props => [
        status,
        index,
      ];

  HomeState copyWith({
    HomeViewStatus? status,
    int? index,
  }) {
    return HomeState(
      status: status ?? this.status,
      index: index ?? this.index,
    );
  }
}
