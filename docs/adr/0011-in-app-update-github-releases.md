# ADR-0011: In-app update via GitHub Releases

- **Status**: Accepted
- **Date**: 2026-10-26

## Context

The release pipeline (ADR-0010) publishes a signed APK to the GitHub Release
page. Users had to learn about a new version manually and side-load it from
the browser. The app already knows its repository and the release always
carries a single `app-release.apk` asset, which is enough for an in-app
update flow without a store.

The proven reference implementation is keek-news: GitHub `releases/latest`
check → version comparison → APK download with progress → system installer
via a `apk_installer` method channel, with the Android
install-unknown-apps permission handled in-flow.

## Decision

Port the keek-news flow onto this app's Clean Architecture layers:

- **Model** (`lib/model/update/`): `AppRelease` (parsed from the GitHub
  release JSON, first `.apk` asset as `downloadUrl`), `DownloadProgress`,
  `UpdateCheckResult`.
- **Service** (`lib/service/`): concrete `ApkDownloadService` (dio download
  to the app-specific external `updates/` dir with progress + cancel) and
  `ApkInstallerService` (method channel bridge). No extra abstraction: the
  repositories are the only consumers and blocs are tested against the
  repository interfaces.
- **Repo** (`lib/repo/update_repo/`, `lib/repo/apk_install_repo/`):
  `UpdateRepo` (latest release, `Either<Failure, AppRelease>`) and
  `ApkInstallRepo` (download stream, installer launch, permission checks),
  both abstract for bloc tests with mocktail.
- **Use case** (`UpdateUseCase`): numeric three-part version comparison
  (build suffix ignored) plus thin delegates to `ApkInstallRepo`.
- **Bloc** (`UpdateBloc` in the settings view): status machine
  idle → checking → available/upToDate/failure, downloading →
  readyToInstall → installPermissionRequired. Download progress arrives via
  chained events (the bloc-events-queue-safe pattern), so cancel is never
  blocked by the running download.
- **UI**: a `FTile` version section in the settings with Korean status text
  and forui buttons; releases without an APK asset fall back to opening the
  release page with `url_launcher`.
- **Android**: `REQUEST_INSTALL_PACKAGES` permission, a `FileProvider` for
  the downloaded APK (`res/xml/file_paths.xml`), and the
  `apk_installer` channel implemented in `MainActivity`.

The check runs when the settings view opens; there is no background or
startup check in v1.

## Consequences

- Users can update entirely in-app on Android; the installer still requires
  the one-time unknown-sources permission, handled by the
  `installPermissionRequired` state.
- The GitHub API is unauthenticated: 60 requests/hour per IP. Acceptable
  for a manual check on settings open.
- iOS remains out of scope (the channel and permission flow are
  Android-only); the version tile still shows the installed version there.
- The downloaded APK is overwritten on every update, so no storage grows
  unbounded.
- `AppRelease` parsing trusts the GitHub payload shape; malformed payloads
  surface as the generic 확인 실패 state.
