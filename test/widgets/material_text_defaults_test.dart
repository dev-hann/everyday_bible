import 'package:everydaybible/widgets/material_text_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  group('MaterialTextDefaults', () {
    testWidgets(
      'bare Text under FScaffold keeps Material text defaults',
      (tester) async {
        await tester.pumpWidget(
          FTheme(
            data: FTheme.neutral.light.touch,
            child: MaterialApp(
              builder: (context, child) =>
                  MaterialTextDefaults(child: child ?? const SizedBox()),
              home: const FScaffold(
                header: FHeader(title: Text('Header')),
                child: Center(child: Text('Body')),
              ),
            ),
          ),
        );

        final style =
            DefaultTextStyle.of(tester.element(find.text('Body'))).style;
        expect(style.decoration, TextDecoration.none);
        expect(style.color, isNot(const Color(0xD0FF0000)));
      },
    );

    testWidgets('renders the child unchanged inside the subtree', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MaterialTextDefaults(child: Text('Inside')),
        ),
      );

      expect(find.text('Inside'), findsOneWidget);
    });
  });
}
