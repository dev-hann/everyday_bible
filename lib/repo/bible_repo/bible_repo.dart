library bible_repo;

import 'package:everydaybible/data_base/data/bible_data_base.dart';
import 'package:everydaybible/data_base/data/box_bible.dart';
import 'package:everydaybible/repo/repo.dart';
part 'bible_impl.dart';

abstract class BibleRepo extends Repo {

  bool isExistDB();
  Future createDB();
  Future clearDB();
  dynamic loadBible();



}
