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
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController();
  final BibleViewStatus status;
  final List<BibleData> bibleDataList;
  final BibleData? selectedData;
  final BibleChapter? selectedChapter;
  final ScrollController scrollController;

  @override
  List<Object?> get props => [
        status,
        bibleDataList,
        selectedData,
        selectedChapter,
        scrollController,
      ];

  BibleState copyWith({
    BibleViewStatus? status,
    List<BibleData>? bibleDataList,
    BibleData? selectedData,
    BibleChapter? selectedChapter,
    ScrollController? scrollController,
  }) {
    return BibleState(
      status: status ?? this.status,
      bibleDataList: bibleDataList ?? this.bibleDataList,
      selectedData: selectedData ?? this.selectedData,
      selectedChapter: selectedChapter ?? this.selectedChapter,
      scrollController: scrollController ?? this.scrollController,
    );
  }
}
