import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:everydaybible/models/quite_time.dart';

class QTWebParser {
  //https://sum.su.or.kr:8888/Ajax/Bible/BodyBible
  //https://sum.su.or.kr:8888/Ajax/Bible/BodyMatterDetail
  //{ 'qt_ty' : 'QT1' , 'Base_de' : '2021-04-06'}

  final _authority = "sum.su.or.kr:8888";

  late String _dateTime;

  Map<String, String> get queryParameter =>
      {'qt_ty': 'QT1', 'Base_de': _dateTime};

  Uri get titleURI =>
      Uri.https(_authority, "Ajax/Bible/BodyMatterDetail", queryParameter);

  Uri get contentsURI =>
      Uri.https(_authority, "Ajax/Bible/BodyBible", queryParameter);

  Map<String, String> get header =>
      {'Content-Type': 'application/json; charset=UTF-8'};

  Future<http.Response> _biblePost(Uri uri) async {
    return await http.post(uri, headers: header);
  }

  Future<QuiteTime> readData(DateTime dateTime) async {
    this._dateTime = QuiteTime.dateTimeFormat(dateTime);
    print("Web Parser : loading $_dateTime Data...");
    final titleJson = await _biblePost(titleURI);
    final contentsJson = await _biblePost(contentsURI);
    return QuiteTime.fromAPI(
      titleJson: jsonDecode(titleJson.body),
      contentsJson: jsonDecode(contentsJson.body),
    );
  }
}
