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
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController();
  final BibleViewStatus status;
  final List<BibleData> bibleDataList;
  final BibleChapter? selectedChapter;
  final ScrollController scrollController;

  @override
  List<Object?> get props => [
        status,
        bibleDataList,
        selectedChapter,
        scrollController,
      ];

  BibleState copyWith({
    BibleViewStatus? status,
    List<BibleData>? bibleDataList,
    BibleChapter? selectedChapter,
    ScrollController? scrollController,
  }) {
    return BibleState(
      status: status ?? this.status,
      bibleDataList: bibleDataList ?? this.bibleDataList,
      selectedChapter: selectedChapter ?? this.selectedChapter,
      scrollController: scrollController ?? this.scrollController,
    );
  }
}
