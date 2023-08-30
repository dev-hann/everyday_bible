library qt_repo;

import 'dart:async';

import 'package:everydaybible/data_base/service/quite_time_service.dart';
import 'package:everydaybible/repo/repo.dart';
part 'quite_time_impl.dart';

abstract class QuiteTimeRepo extends Repo {
  Future<dynamic> requestQuiteTimeData(DateTime dateTime);
  Future<dynamic> requestQuiteTimeBody(DateTime dateTime);
}
