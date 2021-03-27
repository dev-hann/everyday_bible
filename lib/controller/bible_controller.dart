import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_database.dart';
import 'package:everydaybible/utils/bible_web_parser.dart';
import 'package:flutter/material.dart';

class BibleController{

  final BibleDatabase _bibleDatabase = BibleDatabase();
  final BibleWebParser _bibleWebParser = BibleWebParser();

  Bible _bible;

  String get title => _bible.title;

  String get subTitle => _bible.subTitle;

  String get audio => _bible.audio;

  Map<int, String> get gospels => _bible.gospel;


  Future init() async {
    if (_bible == null) {
      print("Loading Today Bible Data..");
      ///1 . check DB
      ///2. if no TodayData => init Parsing
      ///3. save on DB
      ///

      _bible = await _bibleWebParser.bible;
      print("Load Completed!");
    }
  }




}
