import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_web_parser.dart';
import 'package:everydaybible/utils/bible_notification.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BibleDatabase {
  Box<Bible> _database;
  BibleWebParser _bibleWebParser = BibleWebParser();

  Future init() async {
    print("Init Hive DB ..");
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BibleAdapter());
    }
    _database = await Hive.openBox<Bible>("Bible");
    print("Hive Box Opened!");
  }

  Future todayData() async {
    print("Checking Hive DB..");
    if(_database.isNotEmpty) {
      final _data = _database.values.last;
      if (_data.isTodayData()) {
        return _data;
      }
    }
    print("There's no today Data");
    await _database.add(await _bibleWebParser.bible);
    return _database.values.last;
  }
}
