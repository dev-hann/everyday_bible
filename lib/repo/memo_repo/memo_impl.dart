part of 'memo_repo.dart';

class MemoImpl extends MemoRepo {
  final Map<String, dynamic> tmpDB = {};
  final StreamController<List<dynamic>> tmpStreamController =
      StreamController.broadcast();

  @override
  Stream<List<dynamic>> memoListStream() {
    return tmpStreamController.stream;
  }

  @override
  List loadMemoList() {
    return tmpDB.values.toList();
  }

  @override
  Future removeMemo(String index) async {
    tmpDB.remove(index);
    tmpStreamController.add(tmpDB.values.toList());
  }

  @override
  Future updateMemo({
    required String index,
    required Map<String, dynamic> data,
  }) async {
    if (!tmpDB.keys.contains(index)) {
      tmpDB[index] = data;
    } else {
      tmpDB.update(index, (value) => data);
    }
    tmpStreamController.add(tmpDB.values.toList());
  }
}
