import 'package:everydaybible/model/quite_time/quite_time_gospel.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _validMap() => <String, dynamic>{
      'Chapter': 1,
      'Verse': 3,
      'Bible_Cn': '하나님이 가라사대 빛이 있으라 하시니라',
    };

void main() {
  group('QuiteTimeGospel.fromMap', () {
    test('parses chapter, verse and text', () {
      final gospel = QuiteTimeGospel.fromMap(_validMap());

      expect(gospel.chapter, 1);
      expect(gospel.verse, 3);
      expect(gospel.gospel, '하나님이 가라사대 빛이 있으라 하시니라');
    });

    for (final key in _validMap().keys.toList()) {
      test('throws TypeError when `$key` is missing', () {
        final map = _validMap()..remove(key);

        expect(
          () => QuiteTimeGospel.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });
    }
  });

  group('QuiteTimeGospel equality', () {
    test('equal when chapter, verse and text match', () {
      expect(
        QuiteTimeGospel.fromMap(_validMap()),
        QuiteTimeGospel.fromMap(_validMap()),
      );
    });

    test('not equal when the verse number differs', () {
      final other = _validMap()..['Verse'] = 4;

      expect(
        QuiteTimeGospel.fromMap(_validMap()),
        isNot(QuiteTimeGospel.fromMap(other)),
      );
    });

    test('not equal when the text differs', () {
      final other = _validMap()..['Bible_Cn'] = '다른 본문';

      expect(
        QuiteTimeGospel.fromMap(_validMap()),
        isNot(QuiteTimeGospel.fromMap(other)),
      );
    });
  });
}
