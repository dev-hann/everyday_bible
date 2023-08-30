import 'package:dio/dio.dart';

const _url = "https://www.bible.com/api/bible/version/88";

class BibleService {
  final Dio dio = Dio();

  Future<Response> requestBibleData() {
    return dio.get(_url);
  }
}
