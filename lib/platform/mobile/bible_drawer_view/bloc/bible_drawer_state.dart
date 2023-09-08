part of 'bible_drawer_bloc.dart';

enum BibleDrawerViewStatus {
  init,
  loading,
  failure,
  success,
}

class BibleDrawerState extends Equatable {
  BibleDrawerState({
    this.status = BibleDrawerViewStatus.init,
    this.dataList = const [],
    BibleData? currentData,
    BibleChapter? currentChapter,
    TextEditingController? searchController,
    ScrollController? scrollController,
    this.scrollKeyMap = const {},
  })  : searchController = searchController ?? TextEditingController(),
        scrollController = scrollController ?? ScrollController(),
        currentChapter = currentChapter ?? dataList.first.chapterList.first,
        currentData = currentData ?? dataList.first;
  final BibleDrawerViewStatus status;
  final BibleData currentData;
  final BibleChapter currentChapter;
  final List<BibleData> dataList;

  final TextEditingController searchController;
  final ScrollController scrollController;
  final Map<BibleData, GlobalKey> scrollKeyMap;

  @override
  List<Object> get props => [
        status,
        currentData,
        currentChapter,
        dataList,
        scrollKeyMap,
      ];

  BibleDrawerState copyWith(
      {BibleDrawerViewStatus? status,
      BibleData? currentData,
      BibleChapter? currentChapter,
      List<BibleData>? dataList,
      TextEditingController? searchController,
      ScrollController? scrollController,
      Map<BibleData, GlobalKey>? scrollKeyMap}) {
    return BibleDrawerState(
      status: status ?? this.status,
      currentData: currentData ?? this.currentData,
      currentChapter: currentChapter ?? this.currentChapter,
      dataList: dataList ?? this.dataList,
      searchController: searchController ?? this.searchController,
      scrollController: scrollController ?? this.scrollController,
      scrollKeyMap: scrollKeyMap ?? this.scrollKeyMap,
    );
  }
}
