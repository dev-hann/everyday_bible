part of 'update_bloc.dart';

/// Requests an update check against the latest GitHub release.
sealed class UpdateEvent {
  /// Base constructor for update events.
  const UpdateEvent();
}

/// Checks the latest release when the settings view opens.
final class UpdateEventInited extends UpdateEvent {
  /// Creates the event.
  const UpdateEventInited();
}

/// Starts downloading the available update.
final class UpdateEventDownloadTapped extends UpdateEvent {
  /// Creates the event.
  const UpdateEventDownloadTapped();
}

/// Cancels the in-progress download.
final class UpdateEventDownloadCanceled extends UpdateEvent {
  /// Creates the event.
  const UpdateEventDownloadCanceled();
}

/// Restarts the failed download.
final class UpdateEventDownloadRetried extends UpdateEvent {
  /// Creates the event.
  const UpdateEventDownloadRetried();
}

/// Opens the system installer for the downloaded APK.
final class UpdateEventInstallTapped extends UpdateEvent {
  /// Creates the event.
  const UpdateEventInstallTapped();
}

/// Opens the system page granting the install permission.
final class UpdateEventPermissionSettingsTapped extends UpdateEvent {
  /// Creates the event.
  const UpdateEventPermissionSettingsTapped();
}

/// Re-runs the update check after a failure.
final class UpdateEventRetryTapped extends UpdateEvent {
  /// Creates the event.
  const UpdateEventRetryTapped();
}

/// Reports download progress from the active subscription.
final class UpdateEventDownloadProgressed extends UpdateEvent {
  /// Creates a progress event.
  const UpdateEventDownloadProgressed(this.progress);

  /// The latest byte snapshot.
  final DownloadProgress progress;
}

/// Reports a failed or cancelled download.
final class UpdateEventDownloadFailed extends UpdateEvent {
  /// Creates the event.
  const UpdateEventDownloadFailed();
}

/// Reports a completed download.
final class UpdateEventDownloadSucceeded extends UpdateEvent {
  /// Creates the event.
  const UpdateEventDownloadSucceeded();
}
