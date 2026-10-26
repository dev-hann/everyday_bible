import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Resolves the absolute path where the update APK is written.
typedef ApkSavePathResolver = Future<String> Function();

/// Downloads the update APK to a local file with progress reporting.
class ApkDownloadService {
  /// Creates the service.
  ///
  /// [resolveSavePath] defaults to the app-specific external `updates/`
  /// directory and creates it when missing.
  ApkDownloadService({
    Dio? dio,
    ApkSavePathResolver? resolveSavePath,
  })  : _dio = dio ?? Dio(),
        _resolveSavePath = resolveSavePath ?? _defaultSavePath;

  final Dio _dio;

  final ApkSavePathResolver _resolveSavePath;

  CancelToken? _cancelToken;

  String? _savedPath;

  /// Path of the last downloaded file; null before the first download.
  String? get savedPath => _savedPath;

  static Future<String> _defaultSavePath() async {
    final dir = await getExternalStorageDirectory();
    final base = dir?.path ?? '';
    final updates = Directory('$base/updates');
    if (!updates.existsSync()) {
      updates.createSync(recursive: true);
    }
    return '${updates.path}/app-update.apk';
  }

  /// Downloads [url], reporting `(receivedBytes, totalBytes)` to
  /// [onProgress] as data arrives.
  ///
  /// Returns the absolute path of the downloaded file. Throws on network
  /// failure or cancellation.
  Future<String> download(
    String url,
    void Function(int receivedBytes, int totalBytes) onProgress,
  ) async {
    final savePath = await _resolveSavePath();
    _savedPath = savePath;
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
    );

    return savePath;
  }

  /// Cancels an in-progress download and deletes the partial file.
  void cancel() {
    _cancelToken?.cancel();
    _cancelToken = null;
    _deleteSavedFile();
  }

  void _deleteSavedFile() {
    final path = _savedPath;
    if (path == null) return;
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
