part of favorite;

class FavoriteQuiteTime extends Favorite {
  FavoriteQuiteTime()
      : super(
          typeIndex: FavoriteType.quiteTime.index,
        );

  @override
  List<Object?> get props => [
        typeIndex,
      ];
}
