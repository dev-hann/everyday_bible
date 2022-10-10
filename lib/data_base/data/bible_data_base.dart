import 'dart:io';

import 'package:everydaybible/data_base/data/data_base.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const configDir = ".config/everyday_bible";
const dbName = "bible.db";

class BibleDatabase extends DataBase {
  late Database _db;

  @override
  String get dbName => "bible.db";
  String get dbPath => "$configDir/$dbName";
  @override
  bool get isEmpty {
    try {
      return !Directory(dbPath).existsSync();
    } catch (e) {
      return true;
    }
  }

  @override
  Future init() async {
    final needLoadDB = isEmpty;
    await super.init();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _db = await databaseFactory.openDatabase(dbPath);
    if (needLoadDB) {
      await createDB();
    }
  }

  Future createDB() async {
    final sqlFile = File("assets/bible/bible.sql");
    final data = await sqlFile.readAsString();
    final queryList = data.split("\n");
    print("Creating");
    await _db.transaction((txn) async {
      for (final q in queryList) {
        await txn.execute(q);
      }
    });
    print("created");
  }

  Future deleteDB() {
    return deleteDatabase(dbPath);
  }
}
