import 'dart:convert';

import 'package:everydaybible/repo/repo.dart';
import 'package:flutter/services.dart';
part 'bible_impl.dart';

/// Repository exposing the Bible text bundled in the `bible.json` asset.
abstract class BibleRepo extends Repo {
  /// Whether the Bible database has not been initialized yet.
  bool databaseIsEmpty();

  /// Loads and parses `assets/data/bible.json` into memory.
  Future<void> initDataBase();

  /// Returns every Bible entry as a book/chapter key to verses mapping.
  List<MapEntry<String, dynamic>> loadBibleDataList();
}
