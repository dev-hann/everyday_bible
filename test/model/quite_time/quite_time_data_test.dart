import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _validMap() => <String, dynamic>{
      'Qt_ty': 'QT1',
      'Base_de': '2026-10-25',
      'Bible_name': '창세기',
      'Bible_chapter': '1:1-31',
      'Qt_sj': '하나님의 창조',
      'Qt_Brf': '말씀을 요약한 줄',
    };

void main() {
  group('QuiteTimeData.fromMap', () {
    test('parses a valid QT payload', () {
      final data = QuiteTimeData.fromMap(_validMap());

      expect(data.type, 'QT1');
      expect(data.dateTime, DateTime(2026, 10, 25));
      expect(data.bibleName, '창세기');
      expect(data.chapter, '1:1-31');
      expect(data.title, '하나님의 창조');
      expect(data.summary, '말씀을 요약한 줄');
    });

    for (final key in _validMap().keys.toList()) {
      test('throws TypeError when `$key` is missing', () {
        final map = _validMap()..remove(key);

        expect(
          () => QuiteTimeData.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });
    }
  });

  group('QuiteTimeData equality', () {
    test('equal when tracked fields match', () {
      expect(
        QuiteTimeData.fromMap(_validMap()),
        QuiteTimeData.fromMap(_validMap()),
      );
    });

    test('ignores summary (documented props behavior)', () {
      final other = _validMap()..['Qt_Brf'] = '전혀 다른 요약';

      expect(
        QuiteTimeData.fromMap(_validMap()),
        QuiteTimeData.fromMap(other),
      );
    });

    test('not equal when title differs', () {
      final other = _validMap()..['Qt_sj'] = '다른 제목';

      expect(
        QuiteTimeData.fromMap(_validMap()),
        isNot(QuiteTimeData.fromMap(other)),
      );
    });
  });

  group('QuiteTimeData.isSameDateTime', () {
    test('true for the same calendar day at a different time', () {
      final data = QuiteTimeData.fromMap(_validMap());

      expect(
        data.isSameDateTime(DateTime(2026, 10, 25, 23, 59)),
        isTrue,
      );
    });

    test('false for another day', () {
      final data = QuiteTimeData.fromMap(_validMap());

      expect(data.isSameDateTime(DateTime(2026, 10, 26)), isFalse);
    });
  });
}
