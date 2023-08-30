import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

const _url = "https://sum.su.or.kr:8888/Ajax/Bible";

class QuiteTimeService {
  final Dio dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );

  Future<Response> requestData(DateTime dateTime) {
    return dio.post(
      "$_url/BodyMatterDetail",
      data: {
        "qt_ty": "QT1",
        "Base_de": DateFormat("yyyy-MM-dd").format(dateTime),
      },
    );
  }

  Future<Response> requestGospelList(DateTime dateTime) {
    return dio.post(
      "$_url/BodyBible",
      data: {
        "qt_ty": "QT1",
        "Base_de": DateFormat("yyyy-MM-dd").format(dateTime),
      },
    );
  }
}
