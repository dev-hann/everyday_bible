import 'dart:io';

import 'package:everydaybible/data_base/app_database.dart';
import 'package:everydaybible/repo/setting_repo/repo_setting.dart';
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

  // SettingImpl binds to the AppDatabase.instance singleton, whose
  // driftDatabase() executor resolves its file through path_provider.
  // Redirecting that channel points the real singleton at a scratch
  // directory so the actual implementation is under test.
  final dir = Directory('/tmp/opencode/setting-impl-test');
  late SettingImpl repo;

  setUpAll(() {
    dir.createSync(recursive: true);
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => dir.path,
    );
    repo = SettingImpl();
  });

  setUp(() async {
    await AppDatabase.instance.delete(AppDatabase.instance.settings).go();
    await _until(() => repo.loadSetting().isEmpty);
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  test('loads empty settings by default', () {
    expect(repo.loadSetting(), isEmpty);
  });

  test('updateSetting stores values serialized as strings', () async {
    await repo.updateSetting(<String, dynamic>{
      'themeMode': 2,
      'textScaleFactor': 1,
    });
    await _until(() => repo.loadSetting().containsKey('themeMode'));

    expect(repo.loadSetting(), <String, dynamic>{
      'themeMode': '2',
      'textScaleFactor': '1',
    });
  });

  test('updateSetting upserts existing keys instead of duplicating', () async {
    await repo.updateSetting(<String, dynamic>{'themeMode': '2'});
    await _until(() => repo.loadSetting().isNotEmpty);

    await repo.updateSetting(<String, dynamic>{'themeMode': '0'});
    await _until(() => repo.loadSetting()['themeMode'] == '0');

    final rows = await AppDatabase.instance
        .select(AppDatabase.instance.settings)
        .get();

    expect(rows, hasLength(1));
    expect(rows.single.key, 'themeMode');
    expect(rows.single.value, '0');
    expect(repo.loadSetting()['themeMode'], '0');
  });

  test('loadSetting returns a copy of the cache', () {
    final copy = repo.loadSetting();
    copy['injected'] = 'x';

    expect(repo.loadSetting().containsKey('injected'), isFalse);
  });
}
