part of 'bible_bloc.dart';

/// Lifecycle status of the Bible reader view.
enum BibleViewStatus {
  /// The reader has not been initialized yet.
  init,

  /// The Bible data is being loaded.
  loading,

  /// Loading the Bible data failed.
  failure,

  /// The Bible data is loaded and shown.
  success,
}

/// State of the Bible reader: the loaded books, the current selection, and
/// the controllers of the navigation drawer.
class BibleState extends Equatable {
  /// Creates the state, creating fresh drawer controllers when omitted.
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

  /// Lifecycle status of the view.
  final BibleViewStatus status;

  /// All loaded books of the Bible.
  final List<BibleData> bibleDataList;

  /// The book currently selected, if the data is loaded.
  final BibleData? selectedData;

  /// The chapter currently selected, if the data is loaded.
  final BibleChapter? selectedChapter;

  /// Key used to open the reader's drawer.
  final GlobalKey<ScaffoldState> drawerKey;

  /// Controller of the drawer's book search field.
  final TextEditingController drawerSearchController;

  /// Controller of the drawer's chapter list scroll.
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

  /// Returns a copy of this state with the given fields replaced.
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
