import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// App-wide forui theme.
///
/// Single declaration point for every density override — cards, scaffolds,
/// and the calendar — so widgets consume the theme and never carry style
/// deltas of their own.
FThemeData appTheme(Brightness brightness) {
  return (brightness == Brightness.dark
          ? FTheme.neutral.dark.touch
          : FTheme.neutral.light.touch)
      .copyWith(
    cardStyle: const FCardStyleDelta.delta(
      padding: EdgeInsetsGeometryDelta.value(EdgeInsets.all(16)),
    ),
    scaffoldStyle: const FScaffoldStyleDelta.delta(
      childPadding: EdgeInsetsGeometryDelta.value(EdgeInsets.zero),
    ),
    calendarStyle: FCalendarStyleDelta.delta(
      padding: const EdgeInsetsGeometryDelta.value(EdgeInsets.zero),
      dayPickerStyle: const FCalendarDayPickerStyleDelta.delta(
        daySize: Size(40, 40),
      ),
      headerStyle: FCalendarHeaderStyleDelta.delta(
        tappablePadding: const EdgeInsetsGeometryDelta.value(
          EdgeInsetsDirectional.only(start: 2, top: 4, bottom: 4),
        ),
        headerTextStyle: FVariantsDelta.delta([
          FVariantOperation.all(
            const TextStyleDelta.delta(fontSize: 16),
          ),
        ]),
      ),
    ),
  );
}
