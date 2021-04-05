part of view_model;

class MainViewModel extends BibleViewModel {
  MainViewModel(this.database);

  final BibleDatabase database;

  String get title => database.selectedDateBible.title;

  String get subtitle => database.selectedDateBible.subTitle;

  Map<String, String> get gospels => database.selectedDateBible.gospel;

  String get audioAsset => database.selectedDateBible.audio;
}
