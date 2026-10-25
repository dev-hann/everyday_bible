import 'package:everydaybible/model/memo/memo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Memo.fromMap', () {
    test('parses text and dateTime', () {
      final memo = Memo.fromMap(const <String, dynamic>{
        'index': '1000',
        'text': '오늘의 묵상\n첫 줄입니다',
        'dateTime': 1000,
      });

      expect(memo.rawText, '오늘의 묵상\n첫 줄입니다');
      expect(
        memo.dateTime,
        DateTime.fromMillisecondsSinceEpoch(1000),
      );
      expect(memo.index, '1000');
    });

    test('derives index from dateTime, ignoring the stored index key', () {
      final memo = Memo.fromMap(const <String, dynamic>{
        'index': 'stale-value',
        'text': '본문',
        'dateTime': 2000,
      });

      expect(memo.index, '2000');
    });

    test('throws TypeError when text is missing', () {
      expect(
        () => Memo.fromMap(const <String, dynamic>{'dateTime': 1000}),
        throwsA(isA<TypeError>()),
      );
    });

    test('throws TypeError when dateTime is missing', () {
      expect(
        () => Memo.fromMap(const <String, dynamic>{'text': '본문'}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('Memo.toMap', () {
    test('serializes index, text and dateTime millis', () {
      final memo = Memo(
        rawText: '창세기 메모',
        dateTime: DateTime.fromMillisecondsSinceEpoch(42),
      );

      expect(memo.toMap(), <String, dynamic>{
        'index': '42',
        'text': '창세기 메모',
        'dateTime': 42,
      });
    });

    test('round-trips through fromMap', () {
      final original = Memo(
        rawText: '제목\n본문 첫 줄\n본문 둘째 줄',
        dateTime: DateTime.fromMillisecondsSinceEpoch(1234),
      );

      final restored = Memo.fromMap(original.toMap());

      expect(restored, original);
      expect(restored.toMap(), original.toMap());
    });
  });

  group('Memo title and content', () {
    test('splits first line as title and the rest as content', () {
      const rawText = '묵상 제목\n본문 첫 줄\n본문 둘째 줄';
      final memo = Memo(rawText: rawText);

      expect(memo.title, '묵상 제목');
      expect(memo.content, '본문 첫 줄\n본문 둘째 줄');
    });

    test('single-line rawText has empty content', () {
      final memo = Memo(rawText: '한 줄뿐인 메모');

      expect(memo.title, '한 줄뿐인 메모');
      expect(memo.content, '');
    });

    test('empty body has empty title and content', () {
      final memo = Memo();

      expect(memo.title, '');
      expect(memo.content, '');
    });

    test('korean unicode text survives a round-trip', () {
      const rawText = '한글 제목 🙏\n묵상 내용 — 창세기 1:1';
      final restored = Memo.fromMap(Memo(rawText: rawText).toMap());

      expect(restored.rawText, rawText);
      expect(restored.title, '한글 제목 🙏');
      expect(restored.content, '묵상 내용 — 창세기 1:1');
    });
  });

  group('Memo defaults and copies', () {
    test('defaults rawText to empty and dateTime to now', () {
      final before = DateTime.now();
      final memo = Memo();
      final after = DateTime.now();

      expect(memo.rawText, '');
      expect(memo.dateTime.isBefore(before), isFalse);
      expect(memo.dateTime.isAfter(after), isFalse);
    });

    test('copyWith replaces only the given fields', () {
      final memo = Memo(
        rawText: '원본',
        dateTime: DateTime.fromMillisecondsSinceEpoch(10),
      );
      final copied = memo.copyWith(rawText: '변경');

      expect(copied.rawText, '변경');
      expect(copied.dateTime, memo.dateTime);
    });

    test('equality follows rawText and dateTime', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(3000);
      final a = Memo(rawText: '같음', dateTime: dateTime);
      final b = Memo(rawText: '같음', dateTime: dateTime);

      expect(a, b);
      expect(a, isNot(Memo(rawText: '다름', dateTime: dateTime)));
      expect(
        a,
        isNot(
          Memo(
            rawText: '같음',
            dateTime: DateTime.fromMillisecondsSinceEpoch(3001),
          ),
        ),
      );
    });
  });
}
