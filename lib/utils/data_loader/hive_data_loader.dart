import 'package:everydaybible/models/bible.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data_loader.dart';

class HiveDataLoader extends DataLoader with HiveMixin {
 late Box bibleBox;

  @override
  Future<Bible?> bibleFromDate(DateTime dateTime) async {
    String _boxName = bibleFormat(dateTime);
    final _tmpBible = bibleBox.get(_boxName);
    if (_tmpBible == null) {
      print("There's no data in Hive.");
      return null;
    }
    print("loading completed $_boxName's Bible from Hive");
    return Bible.fromHive(Map.from(_tmpBible));
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<Bible?> init() async {
    print("init HiveDataLoader..");
    await Hive.initFlutter();
    bibleBox = await Hive.openBox<dynamic>("Bible");
    return bibleFromDate(DateTime.now());
  }

  void pushBible(Bible bible) {
    String _boxName =bible.dateTime;
    bibleBox.put(_boxName, bible.toMap());
    print("push new Box $_boxName");
  }

}

mixin HiveMixin on DataLoader {}
