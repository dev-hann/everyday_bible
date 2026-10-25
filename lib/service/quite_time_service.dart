import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

const _url = 'https://sum.su.or.kr:8888/Ajax/Bible';

/// Fetches daily Quiet Time (QT) content from the QT API over HTTP.
class QuiteTimeService {
  /// HTTP client used for QT API requests.
  final Dio dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );

  /// Formats [dateTime] as the API date parameter (`yyyy-MM-dd`).
  String dateTimeFormat(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// Requests the QT body detail (title, summary) for [dateTime].
  Future<Response<dynamic>> requestData(DateTime dateTime) {
    return dio.get(
      '$_url/BodyMatterDetail',
      queryParameters: {
        'qt_ty': 'QT1',
        'Base_de': dateTimeFormat(dateTime),
      },
    );
  }

  /// Requests the gospel verse list for [dateTime].
  Future<Response<dynamic>> requestGospelList(DateTime dateTime) {
    return dio.get(
      '$_url/BodyBible',
      queryParameters: {
        'qt_ty': 'QT1',
        'Base_de': dateTimeFormat(dateTime),
      },
    );
  }
}
