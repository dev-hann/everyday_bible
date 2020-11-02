
class Bible{

  static final Bible _bible = Bible._internal();

  factory Bible(){
    return _bible;
  }

  Bible._internal();

  DateTime dateTime = DateTime.now();
  Map<int,String> contents = Map();
  String audio;
  String get title => contents[0];


}