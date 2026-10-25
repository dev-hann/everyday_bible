import 'package:everydaybible/platform/mobile/bible_view/bible_view.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the verses of the first loaded chapter', (
    tester,
  ) async {
    final bloc = BibleBloc(_FakeBibleRepo());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<BibleBloc>.value(
          value: bloc,
          child: const BibleView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('창세기 1장'), findsOneWidget);
    expect(find.byType(VerseText), findsNWidgets(2));
    expect(find.textContaining('태초에 하나님이 천지를 창조하시니라'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('drawer jumps to the selected book and chapter', (tester) async {
    final bloc = BibleBloc(_FakeBibleRepo());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<BibleBloc>.value(
          value: bloc,
          child: const BibleView(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    bloc.state.drawerKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('창세기'), findsOneWidget);
    expect(find.text('요한복음'), findsOneWidget);

    await tester.tap(find.text('요한복음'));
    await tester.pumpAndSettle();

    final johnTile = find.ancestor(
      of: find.text('요한복음'),
      matching: find.byType(ExpansionTile),
    );
    await tester.tap(find.descendant(of: johnTile, matching: find.text('1장')));
    await tester.pumpAndSettle();

    expect(find.text('요한복음 1장'), findsOneWidget);
    expect(find.textContaining('태초에 말씀이 계시니라'), findsOneWidget);
  });

  testWidgets('drawer search filters the book list', (tester) async {
    final bloc = BibleBloc(_FakeBibleRepo());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<BibleBloc>.value(
          value: bloc,
          child: const BibleView(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    bloc.state.drawerKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '요한');
    await tester.pump();

    expect(find.text('창세기'), findsNothing);
    expect(find.text('요한복음'), findsOneWidget);
  });
}

class _FakeBibleRepo extends BibleRepo {
  @override
  bool databaseIsEmpty() => false;

  @override
  Future<void> initDataBase() async {}

  @override
  List<MapEntry<String, dynamic>> loadBibleDataList() {
    return const <MapEntry<String, dynamic>>[
      MapEntry(
        '01',
        <String, dynamic>{
          'name': '창세기',
          'chapterList': <Map<String, dynamic>>[
            <String, dynamic>{
              'verseList': <String>[
                '태초에 하나님이 천지를 창조하시니라',
                '땅이 혼돈하고 공허하며',
              ],
            },
            <String, dynamic>{
              'verseList': <String>['하늘과 땅의 창조된 그 역사가 이러하니라'],
            },
          ],
        },
      ),
      MapEntry(
        '43',
        <String, dynamic>{
          'name': '요한복음',
          'chapterList': <Map<String, dynamic>>[
            <String, dynamic>{
              'verseList': <String>['태초에 말씀이 계시니라'],
            },
          ],
        },
      ),
    ];
  }
}
