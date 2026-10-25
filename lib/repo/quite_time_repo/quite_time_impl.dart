part of 'quite_time_repo.dart';

/// [QuiteTimeRepo] implementation delegating to [QuiteTimeService].
class QuiteTimeImpl extends QuiteTimeRepo {
  /// Dio client that performs the Quiet Time HTTP requests.
  final QuiteTimeService service = QuiteTimeService();

  @override
  Future<dynamic> requestQuiteTimeData(DateTime dateTime) async {
    final res = await service.requestData(dateTime);
    return res.data;
  }

  @override
  Future<dynamic> requestQuiteTimeBody(DateTime dateTime) async {
    final res = await service.requestGospelList(dateTime);
    return res.data;
  }
}
