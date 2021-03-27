import 'dart:async';

import 'package:everydaybible/controller/bible_controller.dart';
import 'package:flutter/foundation.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel(this.controller);

  final BibleController controller;

  String get title => controller.title;

  String get subtitle => controller.subTitle;

  Map<int, String> get gospels => controller.gospels;

  String get audioAsset => controller.audio;
}
