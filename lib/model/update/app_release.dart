import 'package:equatable/equatable.dart';

/// A published GitHub release of the app.
class AppRelease extends Equatable {
  /// Creates a release description.
  const AppRelease({
    required this.version,
    required this.htmlUrl,
    this.downloadUrl,
    this.releaseNotes,
  });

  /// Parses a GitHub `releases/latest` JSON payload.
  ///
  /// [downloadUrl] resolves to the first `.apk` asset and stays null when the
  /// release ships no APK asset.
  factory AppRelease.fromJson(Map<String, dynamic> json) {
    final tagName = (json['tag_name'] ?? '') as String;
    final htmlUrl = (json['html_url'] ?? '') as String;
    final body = (json['body'] ?? '') as String;

    String? downloadUrl;
    final assets = json['assets'];
    if (assets is List<dynamic>) {
      for (final asset in assets) {
        if (asset is Map<String, dynamic>) {
          final name = (asset['name'] ?? '') as String;
          if (name.endsWith('.apk')) {
            downloadUrl = asset['browser_download_url'] as String?;
            break;
          }
        }
      }
    }

    return AppRelease(
      version: _stripVPrefix(tagName),
      htmlUrl: htmlUrl,
      downloadUrl: downloadUrl,
      releaseNotes: body.isNotEmpty ? body : null,
    );
  }

  /// Release version without the leading `v` (derived from the tag name).
  final String version;

  /// Web page of the release.
  final String htmlUrl;

  /// Direct APK download URL; null when the release has no APK asset.
  final String? downloadUrl;

  /// Release notes markdown; null when the release body is empty.
  final String? releaseNotes;

  static String _stripVPrefix(String tagName) =>
      tagName.startsWith('v') ? tagName.substring(1) : tagName;

  @override
  List<Object?> get props => [version, htmlUrl, downloadUrl, releaseNotes];
}
