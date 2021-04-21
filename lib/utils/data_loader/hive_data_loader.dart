import 'package:everydaybible/models/everyday_bible.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data_loader.dart';

class HiveDataLoader extends DataLoader with HiveMixin {
 late Box bibleBox;

  @override
  Future<EverydayBible?> bibleFromDate(DateTime dateTime) async {
    String _boxName = bibleFormat(dateTime);
    final _tmpBible = bibleBox.get(_boxName);
    if (_tmpBible == null) {
      print("There's no data in Hive.");
      return null;
    }
    print("loading completed $_boxName's Bible from Hive");
    return EverydayBible.fromHive(Map.from(_tmpBible));
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future initialize() async {
    print("init HiveDataLoader..");
    await Hive.initFlutter();
    bibleBox = await Hive.openBox<dynamic>("Bible");
  }

  void updateBible(EverydayBible bible) {
    String key =bible.dateTime;
    bibleBox.put(key, bible.toMap());
    print("push new Box $key");
  }

}

mixin HiveMixin on DataLoader {}
