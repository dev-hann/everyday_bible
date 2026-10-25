import 'dart:convert';
import 'dart:typed_data';

import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Mirrors the structure of the bundled assets/data/bible.json
// (top-level book key -> {name, chapterList: [{verseList: []}]}).
const _fakeBibleJson = '''
{
  "GEN": {
    "name": "창세기",
    "chapterList": [
      {"verseList": ["태초에 하나님이 천지를 창조하시니라", "땅이 혼돈하고 공허하며"]},
      {"verseList": ["이런 것이 하늘과 땅과 그 만물이 완성되니라"]}
    ]
  }
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // BibleImpl reads the asset through rootBundle, which routes over
    // the raw 'flutter/assets' binary channel; serve a small fake JSON
    // with the real file's structure.
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      (message) async {
        final key = utf8.decode(
          message!.buffer.asUint8List(
            message.offsetInBytes,
            message.lengthInBytes,
          ),
        );
        if (key.endsWith('assets/data/bible.json')) {
          return ByteData.view(
            Uint8List.fromList(utf8.encode(_fakeBibleJson)).buffer,
          );
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('BibleImpl', () {
    test('fresh repository reports an empty database', () {
      final repo = BibleImpl();

      expect(repo.databaseIsEmpty(), isTrue);
      expect(repo.loadBibleDataList(), isEmpty);
    });

    test('initDataBase loads and decodes the bundled asset', () async {
      final repo = BibleImpl();
      await repo.initDataBase();

      expect(repo.databaseIsEmpty(), isFalse);
      expect(repo.loadBibleDataList(), hasLength(1));
      expect(repo.loadBibleDataList().first.key, 'GEN');
    });

    test('loaded entries feed BibleData.fromMapEntry', () async {
      final repo = BibleImpl();
      await repo.initDataBase();

      final book = BibleData.fromMapEntry(repo.loadBibleDataList().first);

      expect(book.index, 'GEN');
      expect(book.name, '창세기');
      expect(book.chapterList, hasLength(2));
      expect(book.chapterList.first.verseList, hasLength(2));
    });

    test('loadBibleDataList exposes entries injected into tmpDB', () {
      final repo = BibleImpl()
        ..tmpDB = <String, dynamic>{
          'GEN': <String, dynamic>{
            'name': '창세기',
            'chapterList': <Map<String, dynamic>>[],
          },
        };

      expect(repo.databaseIsEmpty(), isFalse);
      expect(repo.loadBibleDataList(), hasLength(1));
      expect(repo.loadBibleDataList().first.key, 'GEN');
    });
  });
}
