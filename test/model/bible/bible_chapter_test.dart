import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BibleChapter', () {
    test('holds the chapter number and verses in order', () {
      const chapter = BibleChapter(
        number: 1,
        verseList: <String>['태초에', '땅이 혼돈하고'],
      );

      expect(chapter.number, 1);
      expect(chapter.verseList, <String>['태초에', '땅이 혼돈하고']);
    });

    test('equal when the number and verses match', () {
      const a = BibleChapter(number: 3, verseList: <String>['빛이 있으라']);
      const b = BibleChapter(number: 3, verseList: <String>['빛이 있으라']);

      expect(a, b);
    });

    test('not equal when the number differs', () {
      const a = BibleChapter(number: 1, verseList: <String>['빛']);
      const b = BibleChapter(number: 2, verseList: <String>['빛']);

      expect(a, isNot(b));
    });

    test('not equal when the verses differ', () {
      const a = BibleChapter(number: 1, verseList: <String>['빛']);
      const b = BibleChapter(number: 1, verseList: <String>['어두움']);

      expect(a, isNot(b));
    });

    test('chapter without verses is empty', () {
      const chapter = BibleChapter(number: 5, verseList: <String>[]);

      expect(chapter.verseList, isEmpty);
    });
  });
}
