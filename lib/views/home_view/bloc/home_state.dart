part of home_bloc;

enum HomeViewStatus {
  init,
  loading,
  success,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeViewStatus.init,
  });
  final HomeViewStatus status;

  @override
  List<Object?> get props => [status];

  HomeState copyWith({
    HomeViewStatus? status,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }
}
