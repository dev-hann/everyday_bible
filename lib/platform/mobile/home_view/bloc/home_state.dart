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
    this.menuType = MobileMenuType.bible,
  });
  final HomeViewStatus status;
  final MobileMenuType menuType;

  @override
  List<Object> get props => [
        status,
        menuType,
      ];

  HomeState copyWith({
    HomeViewStatus? status,
    MobileMenuType? menuType,
  }) {
    return HomeState(
      status: status ?? this.status,
      menuType: menuType ?? this.menuType,
    );
  }
}
