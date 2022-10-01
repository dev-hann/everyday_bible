import 'package:intl/intl.dart';

class QuiteTimeFormat {
  QuiteTimeFormat(this.dateTime);
  final DateTime dateTime;

  int get year => dateTime.year;
  int get month => dateTime.month;
  int get day => dateTime.day;

  factory QuiteTimeFormat.parse(String value) {
    return QuiteTimeFormat(DateTime.parse(value));
  }

  @override
  String toString([String split = "-"]) {
    return DateFormat("yyyy${split}MM${split}dd").format(dateTime);
  }
}
