import 'dart:isolate';

import 'package:everydaybible/constants/bible_const.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_hive_database.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BibleController extends GetxController {
  BibleHiveDatabase _bibleHiveDatabase = BibleHiveDatabase();

  List<Bible> _bibleList = [];

  List<Bible> get bibleList => _bibleList;

  late Bible _selectedBible;
  Bible get selectedBible =>_selectedBible;
  set selectedBible(Bible bible) {
    if (_selectedBible == bible) return;
    _selectedBible = bible;
    _selectedChapter = 0;
    update();
  }

  late int _selectedChapter = 0;
  int get selectedChapterIndex =>_selectedChapter;
  set selectedChapterIndex(int chapter) {
    if (_selectedChapter == chapter) return;
    _selectedChapter = chapter;
    update();
  }

  void init() async {
    await _bibleHiveDatabase.openBox("Bible");
    List<Bible>? _tmpBibleList = _bibleHiveDatabase.readData(null);
    if (_tmpBibleList == null) {
      _tmpBibleList = await _loadBibleData();
      _bibleHiveDatabase.addDataList(_tmpBibleList);
    }
    _bibleList = _tmpBibleList;
    _selectedBible = _bibleList[0];
  }

  Bible _writeBible(Bible _defaultBible, String originData) {
    List<String> splitData = originData.split("\n");
    Bible _tmpBible = _defaultBible;

    Chapter _tmpChapter = Chapter(index: 1, verseList: []);
    Verse _tmpVerse = Verse(verse: "");
    String _tmpTitle="";
    splitData.forEach((element) {
      List<String> _tmp = element.split(" ");

      if (_tmpTitle == "") {
        ///bible title
        ///
        String bibleTitle;
        try {
          int.parse(_tmp[0].substring(1, 2));
          bibleTitle = _tmp[0].substring(0, 1);
        } catch (e) {
          bibleTitle = _tmp[0].substring(0, 2);
        }
        _tmpTitle = bibleTitle;
      }

      ///chapter index
      String _chapterIndex =
          _tmp[0].split(":")[0].replaceAll(_tmpTitle, "");
      int chapterIndex = int.parse(_chapterIndex);

      ///verse
      String verse = _tmp.sublist(1).join(" ");

      _tmpVerse = Verse(verse: verse);

      if (_tmpChapter.index == chapterIndex) {
        _tmpChapter.verseList.add(_tmpVerse);
      } else {
        _tmpBible.chapterList.add(_tmpChapter);
        _tmpChapter = Chapter(index: chapterIndex, verseList: []);
        _tmpChapter.verseList.add(_tmpVerse);
      }
    });
    _tmpBible.chapterList.add(_tmpChapter);

    return _tmpBible;
  }

  /// [todo] use isolate
  Future<List<Bible>> _loadBibleData() async {
    List<Bible> _res = [];

    String _prefix = BibleAssetPathPrefix;
    List<String>_assetList=BibleAssetPath;
    List<String> _titleList=BibleTitleList;
    for (int index =0; index<_assetList.length;index++) {
      print(_titleList[index]);
      String _loadData = await rootBundle.loadString(_prefix + _assetList[index]);
      BibleType _type = _assetList[index][0] == "1" ? BibleType.Old : BibleType.New;
      Bible _tmpBible = Bible(type: _type, title: _titleList[index], chapterList: []);
      _tmpBible = _writeBible(_tmpBible, _loadData);
      _res.add(_tmpBible);
    }
    return _res;
  }
}
