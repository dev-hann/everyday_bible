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
    this.selectedData,
    this.selectedChapter,
    GlobalKey<ScaffoldState>? drawerKey,
    TextEditingController? drawerSearchController,
    ScrollController? drawerScrollController,
  })  : drawerScrollController = drawerScrollController ?? ScrollController(),
        drawerSearchController =
            drawerSearchController ?? TextEditingController(),
        drawerKey = drawerKey ?? GlobalKey();
  final BibleViewStatus status;
  final List<BibleData> bibleDataList;
  final BibleData? selectedData;
  final BibleChapter? selectedChapter;
  final GlobalKey<ScaffoldState> drawerKey;

  final TextEditingController drawerSearchController;
  final ScrollController drawerScrollController;

  @override
  List<Object?> get props => [
        status,
        bibleDataList,
        selectedData,
        selectedChapter,
        drawerKey,
        drawerSearchController,
        drawerScrollController,
      ];

  BibleState copyWith({
    BibleViewStatus? status,
    List<BibleData>? bibleDataList,
    BibleData? selectedData,
    BibleChapter? selectedChapter,
    GlobalKey<ScaffoldState>? drawerKey,
    TextEditingController? drawerSearchController,
    ScrollController? drawerScrollController,
  }) {
    return BibleState(
      status: status ?? this.status,
      bibleDataList: bibleDataList ?? this.bibleDataList,
      selectedData: selectedData ?? this.selectedData,
      selectedChapter: selectedChapter ?? this.selectedChapter,
      drawerKey: drawerKey ?? this.drawerKey,
      drawerSearchController:
          drawerSearchController ?? this.drawerSearchController,
      drawerScrollController:
          drawerScrollController ?? this.drawerScrollController,
    );
  }
}
