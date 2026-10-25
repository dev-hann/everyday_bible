import 'package:everydaybible/model/failure.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeException implements Exception {
  @override
  String toString() => '_FakeException: 묵상 로딩 실패';
}

void main() {
  group('Failure', () {
    test('exposes message and data', () {
      const failure = Failure('네트워크 오류', data: 42);

      expect(failure.message, '네트워크 오류');
      expect(failure.data, 42);
    });

    test('equal when message and data match', () {
      expect(const Failure('같음'), const Failure('같음'));
      expect(
        const Failure('같음', data: <int>[1]),
        const Failure('같음', data: <int>[1]),
      );
    });

    test('not equal when message or data differ', () {
      expect(const Failure('a'), isNot(const Failure('b')));
      expect(
        const Failure('a', data: 1),
        isNot(const Failure('a', data: 2)),
      );
      expect(const Failure('a'), isNot(const Failure('a', data: 1)));
    });
  });

  group('Failure.fromException', () {
    test('uses the exception toString', () {
      expect(
        Failure.fromException(_FakeException()).message,
        '_FakeException: 묵상 로딩 실패',
      );
    });

    test('accepts any thrown value', () {
      expect(Failure.fromException('원시 문자열').message, '원시 문자열');
    });
  });
}
