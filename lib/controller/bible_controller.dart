import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_database.dart';

class BibleController  {

  static final BibleController _bibleController = BibleController._internal();

  factory BibleController(){
    return _bibleController;
  }

  BibleController._internal();


  final BibleDatabase _bibleDatabase = BibleDatabase();

  Bible _bible;

  String get title => _bible.title;

  String get subTitle => _bible.subTitle;

  String get audio => _bible.audio;

  Map<int, String> get gospels => _bible.gospel;


  Future init() async {
    if (_bible == null) {
      print("Loading Today Bible Data..");
      await _bibleDatabase.init();
      _bible = await _bibleDatabase.todayData();
      print("Load Completed!");
    }
  }


}
