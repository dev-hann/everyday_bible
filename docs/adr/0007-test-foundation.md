# ADR-0007: Test suite foundation

- Status: Accepted
- Date: 2026-10-25

## Context

The app shipped with a single widget smoke test. A dependency upgrade +
strict lint pass (ADR-0006) had no regression safety net, and bloc/repo
logic — including a drift schema migration (v1→v2 chat tables) — was
unverified. The project owner asked for a full test pyramid plus test
documentation, developed in an isolated worktree.

## Decision

1. **Test pyramid mirroring `lib/`**: model unit tests → repo integration
   tests (real impls, real drift) → bloc tests (mocktail-mocked repos,
   real use cases) → widget smoke tests per view → e2e via
   `integration_test` (official package; `patrol`/`maestro` rejected — no
   native-permission flows to justify them).
2. **`bloc_test` is excluded.** It cannot resolve: its `test` package
   dependency conflicts with flutter_test's pinned `test_api 0.7.12`,
   build_runner's `analyzer ^14`, and `firebase_ai`'s
   `web_socket_channel ^3` (every compatible `test` version is excluded by
   the combination). Blocs are tested with a hand-rolled
   `stream.listen` + terminal-state-await + `close()` pattern. The key
   subtlety: several blocs chain a follow-up `add()` inside an event
   handler; tests MUST await the terminal state before closing or they hit
   "Cannot add new events after calling close".
3. **`mocktail` for mocking** (resolves cleanly; bloc-ecosystem standard).
4. **Repos tested against the real implementations.** `MemoImpl`/
   `SettingImpl` hard-wire the `AppDatabase.instance` singleton, so tests
   mock the `path_provider` method channel to redirect the real DB into
   `/tmp` instead of faking the DB layer. A `@visibleForTesting
   AppDatabase.forTesting(e)` constructor was added for direct
   schema/migration tests (in-memory `NativeDatabase`).
5. **E2E runs locally / on-demand, not per-PR CI** — emulator cost and
   flakiness outweigh per-push value at this project size.

## Consequences

- (+) 125 tests; analyze-0 + green tests is the change gate, enforced by CI.
- (+) Migration v1→v2 and every bloc's success/failure paths are pinned.
- (+) Patterns documented in `docs/testing.md` — agents/contributors copy them.
- (−) bloc_test's ergonomics (`blocTest` dsl) unavailable; hand-rolled
  harness is slightly more verbose.
- (−) path_provider channel mocking is indirect; a future DI refactor of
  the repo impls (accept an optional `AppDatabase`) would simplify tests.
- (−) E2E depends on a manually started emulator before releases.
