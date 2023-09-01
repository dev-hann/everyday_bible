import 'package:dio/dio.dart';

const _url = "https://www.bible.com";

class BibleService {
  final Dio dio = Dio();

  Future<Response> requestBibleData() {
    return dio.get("$_url/api/bible/version/88");
  }

  Future<Response> requestVerseList(String usfm) {
    return dio.get(
        "$_url/_next/data/dyrln-AQDC54GUBZ-FDh2/ko/bible/88/$usfm.KRV.json");
  }
}
