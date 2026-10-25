import 'package:everydaybible/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots, loads the Bible, and switches between tabs', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 500),
      EnginePhase.sendSemanticsUpdate,
      const Duration(minutes: 5),
    );

    // 1. Bottom navigation shows the four tabs with AI selected first.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('AI'), findsOneWidget);
    expect(find.text('Bible'), findsOneWidget);
    expect(find.text('QuiteTime'), findsOneWidget);
    expect(find.text('Setting'), findsOneWidget);

    // 2. Switch to the Bible tab: the bundled bible.json loads — Genesis 1
    // header and first verse.
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 500),
      EnginePhase.sendSemanticsUpdate,
      const Duration(minutes: 5),
    );
    expect(find.text('창세기 1장'), findsOneWidget);
    expect(find.textContaining('태초에 하나님이 천지를 창조하시니라'), findsOneWidget);

    // 3. QuiteTime tab shows the dashboard calendar.
    // Fixed pumps instead of pumpAndSettle: the daily QT request goes to the
    // network, and its loading spinner animates forever when offline.
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Quite Time'), findsOneWidget);
    expect(find.byType(TableCalendar<Object?>), findsOneWidget);

    // 4. Setting tab shows the theme and text factor options.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.text('Setting'), findsWidgets);
    expect(find.text('Theme :'), findsOneWidget);
    expect(find.text('TextFactor: '), findsOneWidget);
  });
}
