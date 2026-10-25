# ADR-0002: Bible data bundled locally

- Status: Accepted
- Date: 2023 (`b732731` "Fix: bible change to db from api")

## Context

Bible text was originally fetched from a remote API at runtime. That required
network availability, added latency, and made offline reading impossible —
unacceptable for a daily reading app.

## Decision

Bundle the full Bible text as an asset (`assets/data/bible.json`) and load it
into the local database on first run. No network is needed for Bible reading.

## Consequences

- (+) Fully offline reading; instant chapter loads.
- (+) No API dependency, quota, or failure path.
- (−) Larger app bundle (the JSON asset ships with the APK/IPA).
- (−) Text corrections require an app update.
