import 'package:everydaybible/models/bible.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data_loader.dart';

class HiveDataLoader extends DataLoader with HiveMixin {
  @override
  Future<Bible> bibleFromDate(DateTime dateTime) {
    // TODO: implement bibleFromDate
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<Bible> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

}


mixin HiveMixin on DataLoader{

}