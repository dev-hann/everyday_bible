library bible_repo;

import 'package:everydaybible/data_base/service/bible_service.dart';
import 'package:everydaybible/repo/repo.dart';
part 'bible_impl.dart';

abstract class BibleRepo extends Repo {
  Future<dynamic> requestBibleData();
}
