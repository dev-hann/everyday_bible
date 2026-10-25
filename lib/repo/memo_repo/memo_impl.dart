part of 'memo_repo.dart';

/// [MemoRepo] implementation backed by the drift [AppDatabase].
class MemoImpl extends MemoRepo {
  /// Opens the memo table stream and keeps the in-memory cache in sync.
  MemoImpl() {
    _db.select(_db.memos).watch().listen((rows) {
      _cache = _toMaps(rows);
    });
  }
  final AppDatabase _db = AppDatabase.instance;

  List<Map<String, dynamic>> _cache = [];

  static List<Map<String, dynamic>> _toMaps(List<Memo> rows) {
    return rows
        .map(
          (row) => <String, dynamic>{
            'index': row.id,
            'text': row.body,
            'dateTime': row.createdAt,
          },
        )
        .toList();
  }

  @override
  Stream<List<dynamic>> memoListStream() {
    return _db.select(_db.memos).watch().map(_toMaps);
  }

  @override
  List<dynamic> loadMemoList() {
    return _cache;
  }

  @override
  Future<void> removeMemo(String index) async {
    await (_db.delete(_db.memos)..where((tbl) => tbl.id.equals(index))).go();
  }

  @override
  Future<void> updateMemo({
    required String index,
    required Map<String, dynamic> data,
  }) async {
    await _db.into(_db.memos).insertOnConflictUpdate(
          MemosCompanion.insert(
            id: index,
            body: data['text'] as String,
            createdAt: data['dateTime'] as int,
          ),
        );
  }
}
