# ADR-0009: forui as the design system foundation

- **Status**: Accepted
- **Date**: 2026-10-25

## Context

The app had no UI kit, no design tokens, and no shared component layer: views
rely on Material defaults (`ThemeData.light/dark().copyWith`), `Theme.of`
lookups, and three ad-hoc hardcoded colors (drawer `Colors.orange`, memo
delete `Color(0xFFFE4A49)`, memo editor `TextStyle(fontSize: 30)`).
Third-party widgets (`table_calendar`, `flutter_slidable`, `highlight_text`)
follow the Material theme, so consistency depends entirely on Material
defaults.

The goal is a unified UI managed long-term as a design system: components
owned by one system with shared tokens, not per-view ad-hoc styling.

Candidates evaluated (2026-10, pub.dev):

| | forui 0.27 | shadcn_flutter 0.0.55 | flex_color_scheme 9.0 |
|---|---|---|---|
| Kind | component kit (shadcn-style) | component kit | theme/token layer only |
| Stability | Flutter customer test registry, verified publisher | 0.0.x, single maintainer | Flutter Favorite, mature |
| Components | 50+ incl. Calendar/Line Calendar | 84 | none (themes Material) |
| Fit | gradual view-by-view adoption | Material-free core needs interop package | no component ownership |

`flex_color_scheme` was rejected: it themes Material only and does not give
the component layer the design system should own. `shadcn_flutter` was
rejected for its 0.0.x maturity and separate Material interop requirement.
`getwidget` (stale) and `mix` (styling utility, not a kit) were also dropped.

## Decision

Adopt **forui** (`forui: ^0.27.6`) as the design system foundation:

- `FTheme` wraps `MaterialApp` at the app root (`App` in
  `lib/platform/mobile/main.dart`), resolving light/dark from the user's
  `Setting.themeMode`. Phase 0 ships the built-in `FTheme.neutral` presets;
  brand tokens will be generated via `dart run forui theme create`
  (create.forui.dev) and swapped in.
- Migrate views one at a time, each behind the analyze-0 + tests gate:
  setting → memo → chat → bible/drawer → QT dashboard → audio → home.
  The Material `ThemeData` stays in place during migration for
  not-yet-migrated views and third-party widgets.
- `table_calendar` is eventually replaced by forui's calendar widgets so the
  QT dashboard no longer depends on Material theming.
- `flutter_slidable` has no forui equivalent: it stays, but its colors are
  wired to forui tokens.
- Hardcoded colors are replaced with forui tokens as their views migrate.

## Consequences

- forui is pre-1.0; breaking changes are possible between phases. Mitigated
  by its place in Flutter's customer test registry (tested against every
  Flutter change) and by pinning per-phase upgrades.
- Two theme systems coexist until the final phase (Material `ThemeData` +
  `FTheme`). They must agree on brightness; `FTheme` follows `themeMode`.
- Widget tests pump views directly and are unaffected until views adopt
  forui widgets; migrated-view tests must provide an `FTheme` ancestor.
- Full visual consistency is only reached after `table_calendar` and the
  Material `ThemeData` are removed in the last phase.
