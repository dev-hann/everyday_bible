import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  Box db;
  Future init() async {
    await Hive.initFlutter();
   db = await Hive.openBox("Bible");
  }

}