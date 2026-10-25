import 'dart:async';

import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/service/quite_time_service.dart';
part 'quite_time_impl.dart';

/// Repository fetching Quiet Time data from the remote Bible service.
abstract class QuiteTimeRepo extends Repo {
  /// Fetches the raw Quiet Time metadata for [dateTime].
  Future<dynamic> requestQuiteTimeData(DateTime dateTime);

  /// Fetches the raw gospel verse list for [dateTime].
  Future<dynamic> requestQuiteTimeBody(DateTime dateTime);
}
