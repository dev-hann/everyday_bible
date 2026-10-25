# Testing Guide

Test suite layout mirrors `lib/`:

```
test/
├── model/                    # pure unit tests (parsing, equality, defaults)
├── repo/                     # repo integration tests (real impls + drift)
├── data_base/                # drift schema & migration tests
├── platform/mobile/          # widget tests per view
│   └── <feature>_view/bloc/  # bloc tests per feature
└── widget_test.dart          # app boot smoke
integration_test/
└── app_test.dart             # e2e smoke (device/emulator required)
```

## Commands

```bash
flutter test                          # whole suite
flutter test test/model               # one directory
flutter test --plain-name "Inited loads the content of the given date"
flutter test integration_test -d <device-id>   # e2e (needs emulator/device)
```

CI runs `flutter analyze` + `flutter test` on every push/PR. E2E is **not**
in per-PR CI (emulator cost/flakiness) — run it locally before releases.

## Layer conventions

### Models (`test/model/`)

Plain unit tests: `fromMap`/`toMap` round-trips, missing-key behavior,
equality props, defaults. Tests deliberately document *current* quirks
(e.g. `QuiteTimeData` equality excludes `summary`; out-of-range setting
index throws `RangeError`) — if a quirk is intentionally fixed, the failing
test is the signal.

### Repos (`test/repo/`) — real impls against real drift

`MemoImpl`/`SettingImpl` hard-wire `AppDatabase.instance` (no injection
yet), so tests mock the **`plugins.flutter_io/path_provider` method
channel** to redirect the real singleton into a `/tmp` directory:

```dart
TestWidgetsFlutterBinding.ensureInitialized();
tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
  const MethodChannel('plugins.flutter.io/path_provider'),
  (call) async => dirPath,   // both getTemporaryDirectory & app documents
);
```

`BibleImpl` reads the bundled asset via `rootBundle`, so its test mocks the
`flutter/assets` binary channel with a small fake JSON (same shape as
`assets/data/bible.json`), or injects through the public `tmpDB` field.

Drift schema/migration tests use `AppDatabase.forTesting(e)` with a
`NativeDatabase` (see `test/data_base/app_database_migration_test.dart` —
builds a real v1 database file, reopens, asserts the v1→v2 upgrade creates
the chat tables and preserves data).

### Blocs (`test/platform/mobile/**/bloc/`)

**`bloc_test` is NOT used** — it cannot resolve in this project (its `test`
dependency conflicts with flutter_test's pinned `test_api`, build_runner's
`analyzer`, and `firebase_ai`'s `web_socket_channel`; see ADR-0007).
Hand-rolled pattern instead:

```dart
final bloc = BibleBloc(mockRepo);
final states = <BibleState>[];
final sub = bloc.stream.listen(states.add);
bloc.add(const BibleEventInited());
// Wait for the terminal state BEFORE closing — several blocs chain a
// follow-up add() (e.g. BibleBloc._onInited → UpdatedChapter); closing
// early raises "Cannot add new events after calling close".
await bloc.stream.firstWhere((s) => s.status == BibleViewStatus.success);
await bloc.close();
await sub.cancel();
expect(states, equals([loading, success]));
```

- Mock **repos** (abstract interfaces) with mocktail
  (`class _MockXRepo extends Mock implements XRepo {}`) and run the *real*
  use cases.
- Cover both `Either` channels where the bloc handles them (`Left`/`Right`).
- Give streams to mocks with `thenAnswer((_) => stream)` (mocktail 1.x has
  no `thenStream`).

### Widgets (`test/platform/mobile/`)

- Fakes extend the abstract repos — never construct `AudioImpl`/drift in
  widget tests (plugin channels).
- Fake streams must be **finite** (`Stream.value`, `Stream.empty`):
  blocs `await emit.onEach(stream)` on init; an infinite stream blocks the
  bloc's event queue forever.
- Prefer bounded `pump()` over `pumpAndSettle()` when a spinner can spin
  forever (buffering audio player, offline QT dashboard).

### E2E (`integration_test/`)

`integration_test/app_test.dart` boots the real app (real drift DB, real
`bible.json` asset) and walks the nav: Bible tab → Genesis 1:1 text →
QuiteTime calendar → Setting options. Requires a connected device/emulator.
Skip audio playback (real sound) and network-dependent QT content.

## Lint

`very_good_analysis` applies to tests too: public declarations need `///`
docs (keep helpers private: `_FakeXRepo`, `_makeX`), explicit casts at
dynamic boundaries, sorted pubspec deps. Gate for any change:
`flutter analyze` = 0 issues, `flutter test` = all pass.
