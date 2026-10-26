import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/update/app_release.dart';

/// Outcome of comparing the installed version with the latest release.
enum UpdateStatusType {
  /// The installed version is the latest.
  upToDate,

  /// A newer release exists.
  updateAvailable,
}

/// Result of an update check.
class UpdateCheckResult extends Equatable {
  /// Creates a check result.
  const UpdateCheckResult({
    required this.type,
    required this.release,
  });

  /// Whether a newer release is available.
  final UpdateStatusType type;

  /// The latest published release.
  final AppRelease release;

  /// True when [type] is [UpdateStatusType.updateAvailable].
  bool get isUpdateAvailable => type == UpdateStatusType.updateAvailable;

  @override
  List<Object?> get props => [type, release];
}
