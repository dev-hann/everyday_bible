import 'dart:convert';
import 'dart:typed_data';

import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/data_loader/data_loader.dart';
import 'package:http/http.dart' as http;

/// [todo] check internet connection check and timeout.
///
class WebDataLoader extends DataLoader {
  //https://sum.su.or.kr:8888/Ajax/Bible/BodyBible
  //https://sum.su.or.kr:8888/Ajax/Bible/BodyMatterDetail
  //{ 'qt_ty' : 'QT1' , 'Base_de' : '2021-04-06'}

  final _authority = "sum.su.or.kr:8888";

  DateTime _selectedDateTime = DateTime.now();

  Map<String, String> get queryParameter =>
      {'qt_ty': 'QT1', 'Base_de': bibleFormat(_selectedDateTime)};

  Uri get titleURI =>
      Uri.https(_authority, "Ajax/Bible/BodyMatterDetail", queryParameter);

  Uri get contentsURI =>
      Uri.https(_authority, "Ajax/Bible/BodyBible", queryParameter);

  Map<String, String> get header =>
      {'Content-Type': 'application/json; charset=UTF-8'};

  Future<http.Response> _biblePost(Uri uri) async {
    return await http.post(uri, headers: header);
  }


  @override
  Future<Bible?> bibleFromDate(DateTime dateTime) async {
    _selectedDateTime = dateTime;
    final titleJson = await _biblePost(titleURI);
    final contentsJson = await _biblePost(contentsURI);
    return Bible.fromAPI(
      titleJson: jsonDecode(titleJson.body),
      contentsJson: jsonDecode(contentsJson.body),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future initialize() async {}
}
