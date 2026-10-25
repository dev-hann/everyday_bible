import 'package:everydaybible/main.dart' as app;
import 'package:everydaybible/model/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:integration_test/integration_test.dart';

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
    expect(find.byType(FBottomNavigationBar), findsOneWidget);
    expect(find.text('AI'), findsOneWidget);
    expect(find.text('Bible'), findsOneWidget);
    expect(find.text('QuiteTime'), findsOneWidget);
    expect(find.text('Setting'), findsOneWidget);

    // 2. Switch to the Bible tab: the bundled bible.json loads — Genesis 1
    // header and first verse.
    await tester.tap(find.byIcon(FLucideIcons.bookOpen));
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
    await tester.tap(find.byIcon(FLucideIcons.bookmark));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Quite Time'), findsOneWidget);
    expect(find.byType(FCalendar), findsOneWidget);

    // 4. Setting tab shows the theme switch and text factor select.
    await tester.tap(find.byIcon(FLucideIcons.settings));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.text('Setting'), findsWidgets);
    expect(find.byType(FSwitch), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is FSelect<TextScaleFactor>),
      findsOneWidget,
    );
  });
}
