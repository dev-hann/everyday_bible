part of 'update_bloc.dart';

/// Phases of the version check / update flow shown by the settings view.
enum UpdateViewStatus {
  /// No check has run yet.
  idle,

  /// The latest release is being fetched.
  checking,

  /// A newer release is ready to download.
  available,

  /// The installed version is the latest.
  upToDate,

  /// The release check failed.
  failure,

  /// The update APK is downloading.
  downloading,

  /// The download failed.
  downloadFailure,

  /// The APK is downloaded and can be installed.
  readyToInstall,

  /// The install-unknown-apps permission must be granted first.
  installPermissionRequired,
}

/// State of the settings version / update section.
class UpdateState extends Equatable {
  /// Creates the state.
  const UpdateState({
    this.status = UpdateViewStatus.idle,
    this.currentVersion,
    this.release,
    this.progress,
  });

  /// Phase of the flow.
  final UpdateViewStatus status;

  /// Installed app version (e.g. `3.0.0`); null before it resolves.
  final String? currentVersion;

  /// Latest published release; null before a successful check.
  final AppRelease? release;

  /// Latest download byte snapshot; null outside a download.
  final DownloadProgress? progress;

  /// Copies the state replacing the given fields.
  UpdateState copyWith({
    UpdateViewStatus? status,
    String? currentVersion,
    AppRelease? release,
    DownloadProgress? progress,
  }) {
    return UpdateState(
      status: status ?? this.status,
      currentVersion: currentVersion ?? this.currentVersion,
      release: release ?? this.release,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [status, currentVersion, release, progress];
}
