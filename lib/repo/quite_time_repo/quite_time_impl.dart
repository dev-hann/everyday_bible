part of qt_repo;

class QuiteTimeImpl extends QuiteTimeRepo {
  final QuiteTimeService service = QuiteTimeService();

  @override
  Future requestQuiteTimeData(DateTime dateTime) async {
    final res = await service.requestData(dateTime);
    return res.data;
  }

  @override
  Future requestQuiteTimeBody(DateTime dateTime) async {
    final res = await service.requestGospelList(dateTime);
    return res.data;
  }
}
