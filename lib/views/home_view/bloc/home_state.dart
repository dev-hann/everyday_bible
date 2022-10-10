part of home_bloc;

enum HomeViewStatus {
  init,
  loading,
  success,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeViewStatus.init,
    this.paneIndex = 0,
  });
  final HomeViewStatus status;
  final int paneIndex;
  @override
  List<Object?> get props => [
        status,
        paneIndex,
      ];

  HomeState copyWith({
    HomeViewStatus? status,
    int? paneIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      paneIndex: paneIndex ?? this.paneIndex,
    );
  }
}
