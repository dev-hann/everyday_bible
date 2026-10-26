import 'package:equatable/equatable.dart';

/// Byte-level progress of the update APK download.
class DownloadProgress extends Equatable {
  /// Creates a progress snapshot.
  const DownloadProgress({
    required this.receivedBytes,
    required this.totalBytes,
  });

  /// Bytes received so far.
  final int receivedBytes;

  /// Total bytes announced by the server; `0` when unknown.
  final int totalBytes;

  /// Whether the total size is unknown.
  bool get isUnknownSize => totalBytes <= 0;

  /// Completion ratio in percent (`0`-`100`); `0` while the size is unknown.
  int get percent {
    if (isUnknownSize || receivedBytes <= 0) return 0;
    final ratio = receivedBytes / totalBytes;
    if (ratio >= 1) return 100;
    return (ratio * 100).clamp(0, 100).round();
  }

  @override
  List<Object?> get props => [receivedBytes, totalBytes];
}
