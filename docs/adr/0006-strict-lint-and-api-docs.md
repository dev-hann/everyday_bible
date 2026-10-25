# ADR-0006: very_good_analysis strict preset + API doc policy

- Status: Accepted
- Date: 2026-10-25

## Context

The repo shipped with the default Flutter template lint file: base
`flutter_lints`, no strict language modes, no documentation requirements.
An audit found 583 latent issues (350 missing public API docs, implicit
dynamic casts, unhandled discarded futures, bare `catch` blocks). The project
owner wants strict, AI-agent-friendly engineering guardrails.

## Decision

Adopt **very_good_analysis 11** as the single lint preset, replacing
flutter_lints:

- Keep the strict analyzer language modes that ship with the preset
  (strict-casts / strict-raw-types / strict-inference semantics).
- `public_member_api_docs` enforced: every public declaration carries a `///`
  comment — a navigable map for both humans and AI agents.
- No `// ignore:` without a reason comment; no rule disabling.
- All 583 existing violations fixed (146 auto via `dart fix`, the rest by
  hand, preserving nullability and runtime semantics).
- `lib/data_base/*.g.dart` excluded (generated).

## Consequences

- (+) Implicit dynamic casts and swallowed futures can no longer land.
- (+) The codebase is self-documenting at the API surface.
- (+) AI agents get reliable guardrails; `flutter analyze` clean is the gate.
- (−) Higher friction for quick hacks; every new public member needs a doc
  line.
