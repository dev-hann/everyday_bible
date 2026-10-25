import 'dart:io';

import 'package:drift/native.dart';
import 'package:everydaybible/data_base/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

Future<Set<String>> _tableNames(AppDatabase db) async {
  final rows = await db.customSelect(
    "SELECT name FROM sqlite_master WHERE type = 'table' "
    "AND name NOT LIKE 'sqlite_%'",
  ).get();

  return <String>{for (final row in rows) row.read<String>('name')};
}

Future<int> _userVersion(AppDatabase db) async {
  final rows = await db.customSelect('PRAGMA user_version').get();

  return rows.first.read<int>('user_version');
}

void main() {
  final dir = Directory('/tmp/opencode/app-database-migration-test');
  final file = File('${dir.path}/migration.sqlite');

  setUpAll(() {
    dir.createSync(recursive: true);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  tearDownAll(() {
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  test('schemaVersion is 2', () {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    expect(db.schemaVersion, 2);
  });

  test('onCreate creates every table at version 2', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final tables = await _tableNames(db);

    expect(
      tables,
      containsAll(<String>['memos', 'settings']),
    );
    expect(
      tables,
      containsAll(<String>['chat_sessions', 'chat_messages']),
    );
    expect(await _userVersion(db), 2);
  });

  test('onUpgrade from v1 creates chat tables and keeps data', () async {
    // Phase 1: shape a v1 database — only memos and settings exist.
    final v1 = AppDatabase.forTesting(NativeDatabase(file));
    await v1.into(v1.memos).insert(
          MemosCompanion.insert(
            id: '1000',
            body: '구 버전 메모\n본문',
            createdAt: 1000,
          ),
        );
    await v1.into(v1.settings).insert(
          SettingsCompanion.insert(key: 'themeMode', value: '2'),
        );
    await v1.customStatement('DROP TABLE chat_sessions');
    await v1.customStatement('DROP TABLE chat_messages');
    await v1.customStatement('PRAGMA user_version = 1');
    await v1.close();

    // Phase 2: reopen — drift must upgrade 1 -> 2 via onUpgrade.
    final db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db.close);

    final tables = await _tableNames(db);

    expect(
      tables,
      containsAll(<String>['memos', 'settings', 'chat_sessions']),
    );
    expect(tables, contains('chat_messages'));
    expect(await _userVersion(db), 2);

    final memos = await db.select(db.memos).get();
    expect(memos, hasLength(1));
    expect(memos.single.body, '구 버전 메모\n본문');

    final settings = await db.select(db.settings).get();
    expect(settings, hasLength(1));
    expect(settings.single.key, 'themeMode');
    expect(settings.single.value, '2');

    // The freshly created chat tables accept rows.
    await db.into(db.chatSessions).insert(
          ChatSessionsCompanion.insert(
            id: 's1',
            title: '창세기 묵상 대화',
            createdAt: 1,
            updatedAt: 2,
          ),
        );
    await db.into(db.chatMessages).insert(
          ChatMessagesCompanion.insert(
            id: 'm1',
            sessionId: 's1',
            role: 'user',
            content: '창세기 1장을 요약해줘',
            createdAt: 1,
          ),
        );

    expect(await db.select(db.chatSessions).get(), hasLength(1));
    expect(await db.select(db.chatMessages).get(), hasLength(1));
  });
}
