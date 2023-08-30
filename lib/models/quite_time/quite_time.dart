import 'package:everydaybible/models/quite_time/quite_time_data.dart';
import 'package:everydaybible/models/quite_time/quite_time_gospel.dart';

class QuiteTime {
  QuiteTime({
    required this.data,
    required this.gospelList,
  });
  final QuiteTimeData data;
  final List<QuiteTimeGospel> gospelList;
}
