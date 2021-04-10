part of view_model;

class MainViewModel extends BibleViewModel {
  MainViewModel(this.database) {
    _loadBibleFromDB();
    this.database.bibleNotifier.addListener(() {
      _loadBibleFromDB();
      _loadingCompleted();
      gospelScrollController.jumpTo(0.0);
    });
  }

  final BibleDatabase database;

  Bible? _selectedBible;

  void _loadBibleFromDB() {
    _selectedBible = database.bibleNotifier.value!;
  }

  String get title => _selectedBible!.title;

  String get subtitle => _selectedBible!.subTitle;

  Map<String, String> get gospels => _selectedBible!.gospels;

  String get audioAsset => _selectedBible!.audio;

  String get dateTime => _selectedBible!.dateTime;

  bool _loading = false;

  bool get isLoading =>_loading;
  void _loadingMode(){
    _loading = true;
    notifyListeners();
  }
  void _loadingCompleted(){
    _loading = false;
    notifyListeners();
  }

  bool get hasTomorrow => !(_dateTime.difference(DateTime.now()).inDays > 5);

  ScrollController gospelScrollController = ScrollController();

  DateTime get _dateTime {
    List<int> dateList = dateTime.split("-").map((e) => int.parse(e)).toList();
    return DateTime(dateList[0], dateList[1], dateList[2]);
  }

  void onTapYesterday() async {
    _loadingMode();
    notifyListeners();
    await database.loadData(_dateTime.add(Duration(days: -1)));
  }

  void onTapTomorrow() async {
    _loadingMode();
    await database.loadData(_dateTime.add(Duration(days: 1)));
  }
}
