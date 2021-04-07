part of view_model;

class MainViewModel extends BibleViewModel {
  MainViewModel(this.database);

 late final BibleDatabase database;

  String? get title => database.selectedDateBible.title;

  String? get subtitle => database.selectedDateBible.subTitle;

  Map<String, String>? get gospels => database.selectedDateBible.gospels;

  String? get audioAsset => database.selectedDateBible.audio;
}
