library bible_repo;

import 'dart:convert';

import 'package:everydaybible/repo/repo.dart';
import 'package:flutter/services.dart';
part 'bible_impl.dart';

abstract class BibleRepo extends Repo {
  bool databaseIsEmpty();

  Future initDataBase();

  List<MapEntry<String, dynamic>> loadBibleDataList();
}
