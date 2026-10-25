# ADR-0003: Mobile-only scope

- Status: Accepted
- Date: 2026 (`fa20f25` "Remove: desktop platforms (linux/macos/windows) & fluent_ui")

## Context

The app once targeted desktop (Linux/macOS/Windows) via fluent_ui, which
forced adaptive UI layers, platform-specific audio backends (e.g. Linux mpv),
and extra maintenance. Actual usage is overwhelmingly mobile.

## Decision

Remove desktop platform targets and fluent_ui. Target Android/iOS only.
UI code lives under `lib/platform/mobile/`.

## Consequences

- (+) Smaller surface area; single audio stack (just_audio); simpler CI.
- (+) View layer no longer branches on desktop/mobile.
- (−) Re-adding desktop later means resurrecting the platform layer and an
  adaptive UI story.
