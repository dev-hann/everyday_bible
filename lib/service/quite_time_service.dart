import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

const _url = "https://sum.su.or.kr:8888/Ajax/Bible";

class QuiteTimeService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );

  String dateTimeFormat(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  Future<Response> requestData(DateTime dateTime) {
    return dio.get(
      "$_url/BodyMatterDetail",
      queryParameters: {
        "qt_ty": "QT1",
        "Base_de": dateTimeFormat(dateTime),
      },
    );
  }

  Future<Response> requestGospelList(DateTime dateTime) {
    return dio.get(
      "$_url/BodyBible",
      queryParameters: {
        "qt_ty": "QT1",
        "Base_de": dateTimeFormat(dateTime),
      },
    );
  }
}
