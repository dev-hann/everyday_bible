part of view_model;

class MainViewModel extends BibleViewModel {
  MainViewModel(this.controller);

  final BibleController controller;

  String get title => controller.title;

  String get subtitle => controller.subTitle;

  Map<int, String> get gospels => controller.gospels;

  String get audioAsset => controller.audio;
}
