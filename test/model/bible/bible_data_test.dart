import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:flutter_test/flutter_test.dart';

MapEntry<String, dynamic> _genesisEntry() => const MapEntry(
      'GEN',
      <String, dynamic>{
        'name': '창세기',
        'chapterList': <Map<String, dynamic>>[
          <String, dynamic>{
            'verseList': <String>[
              '태초에 하나님이 천지를 창조하시니라',
              '땅이 혼돈하고 공허하며',
            ],
          },
          <String, dynamic>{
            'verseList': <String>['이런 것이 하늘과 땅과 그 만물이 완성되니라'],
          },
        ],
      },
    );

void main() {
  group('BibleData.fromMapEntry', () {
    test('parses the book key, name and chapters', () {
      final book = BibleData.fromMapEntry(_genesisEntry());

      expect(book.index, 'GEN');
      expect(book.name, '창세기');
      expect(book.chapterList, hasLength(2));
    });

    test('numbers chapters 1-based in order', () {
      final book = BibleData.fromMapEntry(_genesisEntry());

      expect(book.chapterList.first.number, 1);
      expect(book.chapterList.last.number, 2);
    });

    test('keeps verses in order inside each chapter', () {
      final book = BibleData.fromMapEntry(_genesisEntry());

      expect(book.chapterList.first.verseList, hasLength(2));
      expect(
        book.chapterList.first.verseList.first,
        '태초에 하나님이 천지를 창조하시니라',
      );
      expect(
        book.chapterList.last.verseList,
        <String>['이런 것이 하늘과 땅과 그 만물이 완성되니라'],
      );
    });

    test('parses a book without chapters to an empty list', () {
      final book = BibleData.fromMapEntry(
        const MapEntry(
          'GEN',
          <String, dynamic>{
            'name': '창세기',
            'chapterList': <Map<String, dynamic>>[],
          },
        ),
      );

      expect(book.chapterList, isEmpty);
    });

    test('throws TypeError when the name is missing', () {
      const entry = MapEntry(
        'GEN',
        <String, dynamic>{
          'chapterList': <Map<String, dynamic>>[],
        },
      );

      expect(
        () => BibleData.fromMapEntry(entry),
        throwsA(isA<TypeError>()),
      );
    });

    test('throws TypeError when the chapterList is missing', () {
      const entry = MapEntry(
        'GEN',
        <String, dynamic>{'name': '창세기'},
      );

      expect(
        () => BibleData.fromMapEntry(entry),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('BibleData equality', () {
    test('equal when key, name and chapters match', () {
      expect(
        BibleData.fromMapEntry(_genesisEntry()),
        BibleData.fromMapEntry(_genesisEntry()),
      );
    });

    test('not equal when the book name differs', () {
      final otherValue = <String, dynamic>{
        ..._genesisEntry().value as Map<String, dynamic>,
        'name': '출애굽기',
      };
      expect(
        BibleData.fromMapEntry(_genesisEntry()),
        isNot(BibleData.fromMapEntry(MapEntry('GEN', otherValue))),
      );
    });
  });
}
