# AGENTS.md

Guidance for AI agents (and humans) working in this repository.

## Project

Everyday Bible — a Flutter mobile app for daily Bible reading: Bible reader,
Quiet Time (QT) dashboard, memo, audio player, settings (dark mode, font size).
Korean Scripture Union QT content. Mobile only (Android/iOS); desktop targets
were removed intentionally (see ADR-0003).

## Commands

```bash
flutter pub get                                  # install deps
flutter analyze                                  # MUST exit with 0 issues
flutter test                                     # test suite
dart format lib test                             # formatting
dart run build_runner build                      # regen drift code (after schema change)
flutter pub upgrade --major-versions             # dependency upgrades
```

CI (`.github/workflows/ci.yml`) runs analyze + test on every push/PR.
Never commit with failing analyze.

## Lint & docs policy

- Preset: **very_good_analysis 11** (`analysis_options.yaml`). Strict mode:
  `strict-casts`, `strict-raw-types`, `strict-inference` are in effect.
- **Every public declaration requires a `///` doc comment**
  (`public_member_api_docs`). Keep them concise and domain-specific
  (Bible/QT/memo/audio). No boilerplate filler.
- Do NOT add `// ignore:` comments or disable rules. Fix the code instead.
  Existing ignores must carry a reason comment.
- At the dynamic/JSON boundary, cast explicitly (`data['x'] as String`,
  `(data['x'] ?? '') as String`). Preserve nullability exactly — a previously
  nullable value stays nullable.
- Fire-and-forget futures: wrap in `unawaited(...)` from `dart:async`.
- Error handling: catch with `on <SpecificException>`; `on Object catch (e)`
  only when a catch-all is genuinely intended.

## Architecture

Clean Architecture, single-way dependency flow:

```
view (widget) → bloc (event/state) → use_case → repo (interface + impl) → data
```

- `lib/model/` — domain models (Bible, QT, Memo, Setting, Audio, Failure).
- `lib/repo/` — repository interfaces + implementations. Return
  `Either<Failure, T>` (fpdart). Implementations talk to drift DB, bundled
  assets, dio, or just_audio.
- `lib/use_case/` — one use case per feature, orchestrates repos.
- `lib/platform/mobile/<feature>_view/` — UI + per-view `bloc/` directory
  (event/state/bloc files, bloc 9.x pattern).
- `lib/data_base/app_database.dart` — drift database. Generated:
  `app_database.g.dart` (**never hand-edit**; regenerate via build_runner).
- `lib/service/`, `lib/widgets/` — shared services and widgets.
- `lib/main.dart` → `lib/platform/mobile/main.dart` — entry + app shell.

Dependency rule: model ← repo ← use_case ← bloc ← view. Never import upwards
(a repo must not import a bloc; a model must not import Flutter widgets).

## Key decisions (see docs/adr/)

- ADR-0001 Clean Architecture + bloc
- ADR-0002 Bible data bundled locally (asset → drift DB), no network API
- ADR-0003 Mobile-only, desktop platforms removed
- ADR-0004 drift replaces hive as storage
- ADR-0005 fpdart for functional error handling (replaced dartz)
- ADR-0006 very_good_analysis strict preset + API docs
- ADR-0007 Test suite foundation
- ADR-0008 Firebase AI Logic for the AI chat feature

When making a new architecture-level decision, add an ADR
(`docs/adr/NNNN-kebab-title.md`) — status, context, decision, consequences.

## Testing

Full guide: [`docs/testing.md`](docs/testing.md). Key rules:

- Test layout mirrors `lib/`. Gate for any change: `flutter analyze` = 0
  issues AND `flutter test` = all pass.
- No `bloc_test` (dependency conflict, ADR-0007) — use the hand-rolled
  stream pattern: listen → add event → `await bloc.stream.firstWhere(
  <terminal state>)` → `close()`. Never close before the terminal state
  (blocs chain follow-up `add()`s).
- Mock repos (abstract interfaces) with mocktail; run real use cases.
- Widget tests: fake repos with finite streams (`Stream.value`) — infinite
  streams deadlock bloc event queues.
- E2E lives in `integration_test/`, runs on a real device only
  (`flutter test integration_test -d <device>`), not in per-PR CI.

## Conventions

- Commits: gitmoji + type — `⬆️ Upgrade: android toolchain`,
  `♻️ Replace: hive -> drift storage`, `🔥 Remove: desktop platforms`.
  Match the existing history style.
- Dependencies in `pubspec.yaml` must stay alphabetically sorted
  (`sort_pub_dependencies`, including the `sdk: flutter` entry).
- Drift schema change → bump `schemaVersion` in `app_database.dart` and add a
  migration step, then regenerate `.g.dart` and commit it (generated code IS
  committed in this repo).
- Locale strings: Korean user-facing text is common and accepted.
