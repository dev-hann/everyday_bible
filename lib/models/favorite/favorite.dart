library favorite;

import 'package:equatable/equatable.dart';
import 'package:everydaybible/enum/favorite_type.dart';

part 'favorite_quite_time.dart';

abstract class Favorite extends Equatable {
  const Favorite({
    required this.typeIndex,
  });
  final int typeIndex;

  FavoriteType get type {
    return FavoriteType.values[typeIndex];
  }
}
