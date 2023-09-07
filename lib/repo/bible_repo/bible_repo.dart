library bible_repo;

import 'dart:convert';

import 'package:everydaybible/data_base/service/bible_service.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
part 'bible_impl.dart';

abstract class BibleRepo extends Repo {
  bool databaseIsEmpty();

  Future initDataBase();

  List<MapEntry<String, dynamic>> loadBibleDataList();
}
