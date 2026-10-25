import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/model/quite_time/quite_time_gospel.dart';

/// A day's Quiet Time: its dashboard data plus the gospel verses.
class QuiteTime {
  /// Creates a Quiet Time bundle.
  QuiteTime({
    required this.data,
    required this.gospelList,
  });

  /// Dashboard data (date, passage, title, summary) of the day.
  final QuiteTimeData data;

  /// Gospel verses of the day's passage, in order.
  final List<QuiteTimeGospel> gospelList;
}
