part of 'bible_bloc.dart';

enum BibleViewStatus {
  init,
  loading,
  failure,
  success,
}

class BibleState extends Equatable {
  BibleState({
    this.status = BibleViewStatus.init,
    this.bibleDataList = const [],
    this.selectedChapter,
    GlobalKey<ScaffoldState>? drawerKey,
  }) : drawerKey = drawerKey ?? GlobalKey();
  final BibleViewStatus status;
  final List<BibleData> bibleDataList;
  final BibleChapter? selectedChapter;
  final GlobalKey<ScaffoldState> drawerKey;

  @override
  List<Object?> get props => [
        status,
        bibleDataList,
        selectedChapter,
        drawerKey,
      ];

  BibleState copyWith({
    BibleViewStatus? status,
    List<BibleData>? bibleDataList,
    BibleChapter? selectedChapter,
    GlobalKey<ScaffoldState>? drawerKey,
  }) {
    return BibleState(
      status: status ?? this.status,
      bibleDataList: bibleDataList ?? this.bibleDataList,
      selectedChapter: selectedChapter ?? this.selectedChapter,
      drawerKey: drawerKey ?? this.drawerKey,
    );
  }
}
