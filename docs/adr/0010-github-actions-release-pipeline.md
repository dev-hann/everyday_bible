# ADR-0010: GitHub Actions release pipeline

- **Status**: Accepted
- **Date**: 2026-10-25

## Context

CI (`.github/workflows/ci.yml`) only runs `flutter analyze` + `flutter test`.
There was no build or distribution step: producing an installable Android APK
was a manual local `flutter build apk` with the release build type signing
with **debug keys** (placeholder TODO in `android/app/build.gradle`).

Two constraints shape the pipeline:

1. Firebase credentials (`lib/firebase_options.dart`,
   `android/app/google-services.json`) are gitignored by policy (ADR-0008,
   contain API keys), so any CI job that analyzes, tests, or builds must
   restore them first. Without this, CI on a fresh checkout fails on the
   missing `firebase_options.dart` import.
2. The keystore and its passwords must never enter the repository.

The proven reference is keek-news's `release.yml`: tag-input
`workflow_dispatch` → sign → build APK → GitHub Release.

## Decision

- **`ci.yml`**: restore both Firebase files from base64 secrets
  (`FIREBASE_OPTIONS_BASE64`, `GOOGLE_SERVICES_JSON_BASE64`) between
  `pub get` and `analyze`.
- **`release.yml`** (new): manual tag-triggered (`workflow_dispatch` with a
  `tag` input, mirroring keek-news):
  checkout tag → Java 17 + Flutter stable → Firebase restore → analyze +
  test (same gate as CI, no lint relaxation) → keystore decode from
  `KEYSTORE_BASE64` + generated `key.properties` →
  `flutter build apk --release --target-platform android-arm,android-arm64` →
  GitHub Release with auto-generated notes via
  `softprops/action-gh-release@v2`.
- **Signing**: `build.gradle` reads `android/key.properties` when present and
  signs release with that keystore; falls back to debug keys otherwise, so
  `flutter run --release` still works without a local keystore.
- **Usage**: push tag `vX.Y.Z`, then
  `gh workflow run release.yml -f tag=vX.Y.Z`.
- Distribution target is the GitHub Release page (sideload). Play Store is
  out of scope.

## Consequences

- Secrets must exist before a CI run that needs them: set the six secrets
  (`FIREBASE_OPTIONS_BASE64`, `GOOGLE_SERVICES_JSON_BASE64`,
  `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`) once
  per repository.
- The keystore in `android/app/release.keystore` (gitignored) is the only
  way to sign updates under the same identity; losing it or its passwords
  (recovered from `android/key.properties`) means a new app identity.
- APK contains arm + arm64 only; x86_64 emulators need a separate build.
- iOS distribution (certificates, provisioning) remains manual/local.
- Fork PRs cannot access secrets; CI restore fails there. Acceptable for a
  personal repository where branches live in-repo.
