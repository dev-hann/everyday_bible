import 'dart:async';

import 'package:everydaybible/repo/repo.dart';

part 'memo_impl.dart';

abstract class MemoRepo extends Repo {
  Stream<List<dynamic>> memoListStream();

  Future updateMemo({
    required String index,
    required Map<String, dynamic> data,
  });
  Future removeMemo(String index);

  List<dynamic> loadMemoList();
}
