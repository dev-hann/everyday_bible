import 'dart:async';

import 'package:everydaybible/data_base/app_database.dart';
import 'package:everydaybible/repo/repo.dart';

part 'memo_impl.dart';

/// Repository persisting memos in the drift `memos` table.
abstract class MemoRepo extends Repo {
  /// Stream of the full memo list, re-emitted on every table change.
  Stream<List<dynamic>> memoListStream();

  /// Upserts the memo identified by [index] with the fields in [data].
  Future<void> updateMemo({
    required String index,
    required Map<String, dynamic> data,
  });

  /// Deletes the memo identified by [index].
  Future<void> removeMemo(String index);

  /// Returns the memo list cached from the latest table change.
  List<dynamic> loadMemoList();
}
