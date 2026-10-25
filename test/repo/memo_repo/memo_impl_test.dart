import 'dart:io';

import 'package:everydaybible/data_base/app_database.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _until(bool Function() condition) async {
  for (var attempt = 0; attempt < 200; attempt++) {
    if (condition()) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // MemoImpl binds to the AppDatabase.instance singleton, whose
  // driftDatabase() executor resolves its file through path_provider.
  // Redirecting that channel points the real singleton at a scratch
  // directory so the actual implementation is under test.
  final dir = Directory('/tmp/opencode/memo-impl-test');
  late MemoImpl repo;

  setUpAll(() async {
    dir.createSync(recursive: true);
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => dir.path,
    );
    repo = MemoImpl();
    await repo.memoListStream().first;
  });

  setUp(() async {
    await AppDatabase.instance.delete(AppDatabase.instance.memos).go();
    await _until(() => repo.loadMemoList().isEmpty);
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  test('starts with an empty memo list', () {
    expect(repo.loadMemoList(), isEmpty);
  });

  test('updateMemo upserts a memo and the stream emits it', () async {
    final emitted = expectLater(
      repo.memoListStream(),
      emitsThrough(
        predicate<List<dynamic>>((list) => list.length == 1),
      ),
    );

    await repo.updateMemo(
      index: '1000',
      data: <String, dynamic>{'text': '묵상 제목\n본문', 'dateTime': 1000},
    );
    await emitted;
    await _until(() => repo.loadMemoList().length == 1);

    expect(repo.loadMemoList().single, <String, dynamic>{
      'index': '1000',
      'text': '묵상 제목\n본문',
      'dateTime': 1000,
    });
  });

  test('updateMemo on an existing index replaces the row', () async {
    await repo.updateMemo(
      index: '1000',
      data: <String, dynamic>{'text': '첫 번째 내용', 'dateTime': 1000},
    );
    await _until(() => repo.loadMemoList().length == 1);

    final emitted = expectLater(
      repo.memoListStream(),
      emitsThrough(
        predicate<List<dynamic>>((list) {
          if (list.length != 1) {
            return false;
          }
          final row = list.single as Map<String, dynamic>;
          return row['text'] == '수정된 내용';
        }),
      ),
    );

    await repo.updateMemo(
      index: '1000',
      data: <String, dynamic>{'text': '수정된 내용', 'dateTime': 1000},
    );
    await emitted;
    await _until(() {
      final rows = repo.loadMemoList();
      if (rows.length != 1) {
        return false;
      }
      final row = rows.single as Map<String, dynamic>;
      return row['text'] == '수정된 내용';
    });

    final row = repo.loadMemoList().single as Map<String, dynamic>;
    expect(row['text'], '수정된 내용');
  });

  test('updateMemo persists into the drift memos table', () async {
    await repo.updateMemo(
      index: '1000',
      data: <String, dynamic>{'text': '저장된 메모', 'dateTime': 1000},
    );
    await _until(() => repo.loadMemoList().length == 1);

    final rows =
        await AppDatabase.instance.select(AppDatabase.instance.memos).get();

    expect(rows, hasLength(1));
    expect(rows.single.id, '1000');
    expect(rows.single.body, '저장된 메모');
    expect(rows.single.createdAt, 1000);
  });

  test('removeMemo deletes the row and the stream re-emits empty', () async {
    await repo.updateMemo(
      index: '1000',
      data: <String, dynamic>{'text': '지울 메모', 'dateTime': 1000},
    );
    await _until(() => repo.loadMemoList().length == 1);

    final emitted = expectLater(
      repo.memoListStream(),
      emitsThrough(
        predicate<List<dynamic>>((list) => list.isEmpty),
      ),
    );

    await repo.removeMemo('1000');
    await emitted;
    await _until(() => repo.loadMemoList().isEmpty);

    expect(repo.loadMemoList(), isEmpty);
  });

  test('memoListStream emits again after a second insert', () async {
    final emitted = expectLater(
      repo.memoListStream(),
      emitsThrough(
        predicate<List<dynamic>>((list) => list.length == 2),
      ),
    );

    await repo.updateMemo(
      index: '1000',
      data: <String, dynamic>{'text': '첫 메모', 'dateTime': 1000},
    );
    await repo.updateMemo(
      index: '2000',
      data: <String, dynamic>{'text': '둘째 메모', 'dateTime': 2000},
    );
    await emitted;
    await _until(() => repo.loadMemoList().length == 2);

    final indexes = repo
        .loadMemoList()
        .map((row) => (row as Map<String, dynamic>)['index'])
        .toList();

    expect(indexes, containsAll(<String>['1000', '2000']));
    expect(indexes, hasLength(2));
  });
}
