# ADR-0001: Clean Architecture + bloc pattern

- Status: Accepted
- Date: 2023 (project restructure, `d17cdf3`..`d48c4b0` era)

## Context

The app started as a simple script-style Flutter app. As features grew
(Bible reader, QT, memo, audio, settings), state management and data access
became entangled, and desktop/mobile platform code shared one tree.

## Decision

Adopt Clean Architecture with a single-way dependency flow:

`view → bloc → use_case → repo → data`

- One bloc per feature view (`lib/platform/mobile/<feature>_view/bloc/`).
- Repositories expose interfaces with fpdart `Either<Failure, T>` returns.
- Domain models live in `lib/model/` and depend on nothing above them.

## Consequences

- (+) Features are isolated; blocs stay small and testable.
- (+) Swapping storage (later: hive → drift, ADR-0004) touched only repo impls.
- (−) More files and boilerplate per feature than a flat structure.
