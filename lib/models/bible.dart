

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'bible.g.dart';
@HiveType(typeId: 0)
class Bible {
  Bible({this.title, this.audio, this.gospel, this.subTitle,this.dateTime});

  @HiveField(0)
  final String dateTime;

  @HiveField(1)
  final Map<int, String> gospel;

  @HiveField(2)
  final String audio;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String subTitle;

bool isTodayData(){
  if(this.dateTime == DateFormat('yyyy.MM.dd').format(DateTime.now())){
    return true;
  }
  return false;
}

}
