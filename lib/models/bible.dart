import 'package:intl/intl.dart';

class Bible {
  Bible({
    required this.title,
    required this.brief,
    required this.audio,
    required this.gospels,
    required this.subTitle,
    required this.dateTime,
  });

  final String dateTime;

  final Map<String, String> gospels;

  final String audio;

  final String title;

  final String brief;

  final String subTitle;

  bool isTodayData() {
    if (this.dateTime == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      return true;
    }
    return false;
  }

  factory Bible.fromHive(Map<String, dynamic> json) {
    return Bible(
      title: json['Title'],
      brief: json['Brief'],
      subTitle: json['SubTitle'],
      dateTime: json['DateTime'],
      audio: json['Audio'],
      gospels: Map.from(json['Gospels']),
    );
  }

  factory Bible.fromAPI({
    required Map<String, dynamic> titleJson,
    required List<dynamic> contentsJson,
  }) {

    String _getAudio(String bibleDateFormat) {
      String _years = bibleDateFormat.split("-")[0];
      return "https://meditation.su.or.kr/meditation_mp3/" +
          _years+ "/" + bibleDateFormat.replaceAll('-', "")+ ".mp3";
    }

    Map<String,String> getGospels(List<dynamic> gospelsJson){
      Map<String,String> _tmpGospels={};
      contentsJson.forEach((element) {
        _tmpGospels[element['Verse'].toString()]=element['Bible_Cn'];
      });
      return _tmpGospels;
    }

    return Bible(
      title: (titleJson['Qt_sj'] as String).trim(),
      brief: titleJson['Qt_Brf'],
      subTitle: titleJson['Bible_name'] +" "+ titleJson['Bible_chapter'],
      gospels: getGospels(contentsJson),
      audio: _getAudio(titleJson['Base_de']),
      dateTime: titleJson['Base_de'],
    );
  }


  @override
  String toString() {
    return 'Bible{dateTime: $dateTime, gospels: $gospels, audio: $audio, title: $title, subTitle: $subTitle}';
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'DateTime': this.dateTime,
      'Gospels': this.gospels,
      'Audio': this.audio,
      'Title': this.title,
      'Brief': this.brief,
      'SubTitle': this.subTitle,
    } as Map<String, dynamic>;
  }
}
