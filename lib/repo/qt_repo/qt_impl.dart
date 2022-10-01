part of qt_repo;

class QTImpl extends QTRepo {
  final QTService service = QTService();
  @override
  Future init() async {}

  @override
  Future requestTitle(String dateTime) async {
    final res = await service.requestTitle(dateTime);
    return res.data;
  }

  @override
  Future requestQT(String dateTime) async {
    final res = await service.requestQT(dateTime);
    return res.data;
  }
}
