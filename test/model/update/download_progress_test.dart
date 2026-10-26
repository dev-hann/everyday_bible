import 'package:everydaybible/model/update/download_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DownloadProgress', () {
    test('percent is 0 while the total size is unknown', () {
      const progress = DownloadProgress(receivedBytes: 100, totalBytes: 0);

      expect(progress.isUnknownSize, isTrue);
      expect(progress.percent, 0);
    });

    test('percent is 0 before any byte arrives', () {
      const progress = DownloadProgress(receivedBytes: 0, totalBytes: 200);

      expect(progress.percent, 0);
    });

    test('percent rounds the received ratio', () {
      const progress = DownloadProgress(receivedBytes: 50, totalBytes: 200);

      expect(progress.percent, 25);
    });

    test('percent caps at 100', () {
      const progress = DownloadProgress(receivedBytes: 300, totalBytes: 200);

      expect(progress.percent, 100);
    });

    test('equality follows the byte counters', () {
      const a = DownloadProgress(receivedBytes: 1, totalBytes: 2);
      const b = DownloadProgress(receivedBytes: 1, totalBytes: 2);
      const c = DownloadProgress(receivedBytes: 2, totalBytes: 2);

      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
