library qt_repo;

import 'dart:async';

import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/service/quite_time_service.dart';
part 'quite_time_impl.dart';

abstract class QuiteTimeRepo extends Repo {
  Future<dynamic> requestQuiteTimeData(DateTime dateTime);
  Future<dynamic> requestQuiteTimeBody(DateTime dateTime);
}
