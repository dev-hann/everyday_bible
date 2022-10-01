import 'dart:typed_data';
import 'package:everydaybible/models/hive_model.dart';
import 'package:everydaybible/models/quite_time_format.dart';
import 'package:intl/intl.dart';

class QuiteTime {
  QuiteTime({
    required this.dateTime,
    required this.title,
    required this.brief,
    required this.subTitle,
    required this.gospelList,
  });
  final QuiteTimeFormat dateTime;
  final String title;
  final String brief;
  final String subTitle;
  final Map<String, String> gospelList;

  String get audioURL {
    return "https://meditation.su.or.kr/meditation_mp3/${dateTime.year}/${dateTime.toString("")}.mp3";
  }

  factory QuiteTime.fromMap({
    required Map<String, dynamic> titleJson,
    required List<dynamic> contentsJson,
  }) {
    Map<String, String> _gospels(List<dynamic> gospelsJson) {
      Map<String, String> _tmpGospels = {};
      contentsJson.forEach((element) {
        _tmpGospels[element['Verse'].toString()] = element['Bible_Cn'];
      });
      return _tmpGospels;
    }

    return QuiteTime(
      dateTime: QuiteTimeFormat.parse(titleJson['Base_de']),
      title: (titleJson['Qt_sj'] as String).trim(),
      brief: titleJson['Qt_Brf'],
      subTitle: titleJson['Bible_name'] + " " + titleJson['Bible_chapter'],
      gospelList: _gospels(contentsJson),
    );
  }
}

class QuiteTimeOld extends Box {
  QuiteTimeOld({
    required this.title,
    required this.brief,
    required this.audioURL,
    this.audioByteData,
    required this.gospels,
    required this.subTitle,
    required this.dateTime,
  });

  final String dateTime;

  final Map<String, String> gospels;

  final String title;

  final String brief;

  final String subTitle;

  final String audioURL;

  Uint8List? audioByteData;

  void setAudioByteData(Uint8List data) {
    audioByteData = data;
  }

  factory QuiteTimeOld.fromHive(Map<String, dynamic> json) {
    return QuiteTimeOld(
      title: json['Title'],
      brief: json['Brief'],
      subTitle: json['SubTitle'],
      dateTime: json['DateTime'],
      audioURL: json['AudioURL'],
      audioByteData: json['AudioByteData'],
      gospels: Map.from(json['Gospels']),
    );
  }

  factory QuiteTimeOld.fromAPI({
    required Map<String, dynamic> titleJson,
    required List<dynamic> contentsJson,
  }) {
    Map<String, String> _gospels(List<dynamic> gospelsJson) {
      Map<String, String> _tmpGospels = {};
      contentsJson.forEach((element) {
        _tmpGospels[element['Verse'].toString()] = element['Bible_Cn'];
      });
      return _tmpGospels;
    }

    String _audioURL(String bibleDateFormat) {
      String _years = bibleDateFormat.split("-")[0];
      return "https://meditation.su.or.kr/meditation_mp3/" +
          _years +
          "/" +
          bibleDateFormat.replaceAll('-', "") +
          ".mp3";
    }

    return QuiteTimeOld(
      title: (titleJson['Qt_sj'] as String).trim(),
      brief: titleJson['Qt_Brf'],
      subTitle: titleJson['Bible_name'] + " " + titleJson['Bible_chapter'],
      audioURL: _audioURL(titleJson['Base_de']),
      gospels: _gospels(contentsJson),
      dateTime: titleJson['Base_de'],
    );
  }

  @override
  String toString() {
    return 'Bible{dateTime: $dateTime, gospels: $gospels, title: $title, subTitle: $subTitle}';
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'DateTime': this.dateTime,
      'Gospels': this.gospels,
      'AudioURL': this.audioURL,
      'AudioByteData': this.audioByteData,
      'Title': this.title,
      'Brief': this.brief,
      'SubTitle': this.subTitle,
    } as Map<String, dynamic>;
  }

  static String dateTimeFormat(DateTime dateTime) =>
      DateFormat("yyyy-MM-dd").format(dateTime);
}
