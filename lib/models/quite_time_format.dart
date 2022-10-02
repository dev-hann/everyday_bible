import 'package:intl/intl.dart';

class QuiteTimeFormat {
  QuiteTimeFormat(this.dateTime);
  final DateTime dateTime;

  int get year => dateTime.year;
  int get month => dateTime.month;
  int get day => dateTime.day;

  static String duration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    // TODO: handle Hour
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  factory QuiteTimeFormat.parse(String value) {
    return QuiteTimeFormat(DateTime.parse(value));
  }

  @override
  String toString([String split = "-"]) {
    return DateFormat("yyyy${split}MM${split}dd").format(dateTime);
  }
}
