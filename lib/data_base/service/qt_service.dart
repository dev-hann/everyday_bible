import 'package:dio/dio.dart';

const authority = "sum.su.or.kr:8888";

class QTService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );


  // DateTime format to 'yyyy-MM-dd'
  Map<String, String> _params(String dateTime) {
    return {'qt_ty': 'QT1', 'Base_de': dateTime};
  }

  Future<Response> requestTitle(String dateTime) {
    return dio.postUri(
      Uri.https(
        authority,
        "Ajax/Bible/BodyMatterDetail",
        _params(
          dateTime,
        ),
      ),
    );
  }

  Future<Response> requestQT(String dateTime) {
    return dio.postUri(
      Uri.https(
        authority,
        "Ajax/Bible/BodyBible",
        _params(dateTime),
      ),
    );
  }
}
