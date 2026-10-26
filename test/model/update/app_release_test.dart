import 'package:everydaybible/model/update/app_release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRelease.fromJson', () {
    test('parses tag, url and the first apk asset', () {
      final release = AppRelease.fromJson(const <String, dynamic>{
        'tag_name': 'v3.1.0',
        'html_url':
            'https://github.com/dev-hann/everyday_bible/releases/tag/v3.1.0',
        'body': "## What's Changed",
        'assets': <dynamic>[
          <String, dynamic>{
            'name': 'app-release.apk',
            'browser_download_url':
                'https://github.com/dev-hann/everyday_bible/download/app-release.apk',
          },
        ],
      });

      expect(release.version, '3.1.0');
      expect(release.htmlUrl, startsWith('https://github.com/dev-hann/'));
      expect(
        release.downloadUrl,
        'https://github.com/dev-hann/everyday_bible/download/app-release.apk',
      );
      expect(release.releaseNotes, "## What's Changed");
    });

    test('keeps downloadUrl null when the release has no apk asset', () {
      final release = AppRelease.fromJson(const <String, dynamic>{
        'tag_name': 'v3.0.0',
        'html_url': 'https://github.com/dev-hann/everyday_bible',
        'body': '',
        'assets': <dynamic>[
          <String, dynamic>{
            'name': 'source.zip',
            'browser_download_url': 'https://github.com/dev-hann/source.zip',
          },
        ],
      });

      expect(release.version, '3.0.0');
      expect(release.downloadUrl, isNull);
      expect(release.releaseNotes, isNull);
    });

    test('defaults every field when the payload is empty', () {
      final release = AppRelease.fromJson(const <String, dynamic>{});

      expect(release.version, '');
      expect(release.htmlUrl, '');
      expect(release.downloadUrl, isNull);
      expect(release.releaseNotes, isNull);
    });

    test('skips non-map asset entries instead of crashing', () {
      final release = AppRelease.fromJson(const <String, dynamic>{
        'tag_name': 'v3.0.0',
        'html_url': 'https://github.com/dev-hann/everyday_bible',
        'assets': <dynamic>[
          'not-a-map',
          <String, dynamic>{
            'name': 'app-release.apk',
            'browser_download_url': 'https://github.com/dev-hann/a.apk',
          },
        ],
      });

      expect(release.downloadUrl, 'https://github.com/dev-hann/a.apk');
    });

    test('equality follows all tracked fields', () {
      const a = AppRelease(
        version: '3.0.0',
        htmlUrl: 'https://github.com/a',
      );
      const b = AppRelease(
        version: '3.0.0',
        htmlUrl: 'https://github.com/a',
      );
      const c = AppRelease(
        version: '3.0.1',
        htmlUrl: 'https://github.com/a',
      );

      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
