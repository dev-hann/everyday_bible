# ADR-0005: fpdart for functional error handling

- Status: Accepted
- Date: 2024 (dartz dependency replaced by fpdart in pubspec)

## Context

Repository results originally used dartz for `Either<Failure, T>`. dartz is
unmaintained and lacks Dart 3-era ergonomics. The README kept pointing at
dartz long after the code moved on.

## Decision

Use fpdart as the functional programming library. Repositories return
`Either<Failure, T>` (and `Option<T>` where absence is not an error);
use cases fold over them; blocs map left values to error states.

## Consequences

- (+) Actively maintained, null-safe, smaller API surface.
- (+) Uniform failure channel through the whole stack (`lib/model/failure.dart`).
- (−) Mix of dartz/fpdart knowledge in old docs (README fixed 2026-10).
