
class Bible{
  static final Bible _bible = Bible._internal();

  factory Bible(){
    return _bible;
  }

  Bible._internal();

  DateTime _dateTime = DateTime.now();
  Map<int,String> contents = Map();
  String audio;
  String title;

  get dateTime =>_dateTime;
}