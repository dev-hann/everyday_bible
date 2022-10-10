import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const configDir = ".config/everyday_bible";
const dbName = "bible.db";

class BibleDatabase {
  late Database _db;

  String get bibleDir {
    return "/home/${Platform.environment["USER"]}/$configDir";
  }

  Future init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final dir = Directory(bibleDir);
    final isExist = await dir.exists();
    if (!isExist) {
      await dir.create();
    }
    _db = await databaseFactory.openDatabase("$bibleDir/$dbName");
  }

  Future loadBible() async {
    final sqlFile = File("assets/bible/bible.sql");
    final data = await sqlFile.readAsString();
    final queryList = data.split("\n");
  }
}
