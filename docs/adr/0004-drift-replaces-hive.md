# ADR-0004: drift replaces hive as local storage

- Status: Accepted
- Date: 2026-10 (`95f8bfa` "Replace: hive -> drift storage")

## Context

hive/hive_flutter were used for persistence, but the package family's latest
releases cap their SDK at Dart `<3.0.0` — they do not resolve on a current
Dart 3 toolchain. The app already needed relational queries (QT by date,
memo ordering) that a key-value box handles poorly.

## Decision

Migrate all persistence to drift (SQLite):

- `lib/data_base/app_database.dart` defines tables and the database.
- Generated code in `app_database.g.dart` (build_runner; committed to the repo).
- Repos (memo, QT, setting) query the database instead of hive boxes.

## Consequences

- (+) Dart 3 / current toolchain compatible (hive is not).
- (+) Real queries, migrations (`schemaVersion`), and type-safe SQL.
- (−) Codegen step required after schema changes.
- (−) A one-time data migration path from hive was not shipped (fresh install
  expected).
