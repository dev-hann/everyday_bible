part of 'bible_bloc.dart';

enum BibleViewStatus {
  init,
  loading,
  failure,
  success,
}

class BibleState extends Equatable {
  const BibleState({
    this.status = BibleViewStatus.init,
    this.bibleDataList = const [],
  });
  final BibleViewStatus status;
  final List<BibleData> bibleDataList;

  @override
  List<Object> get props => [
        status,
        bibleDataList,
      ];

  BibleState copyWith({
    BibleViewStatus? status,
    List<BibleData>? bibleDataList,
  }) {
    return BibleState(
      status: status ?? this.status,
      bibleDataList: bibleDataList ?? this.bibleDataList,
    );
  }
}
