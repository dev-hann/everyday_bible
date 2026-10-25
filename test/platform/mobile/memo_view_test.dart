import 'dart:async';

import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/platform/mobile/memo_edit_view/memo_editor_view.dart';
import 'package:everydaybible/platform/mobile/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/platform/mobile/memo_view/memo_view.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  testWidgets('renders the memo list from the repo cache', (tester) async {
    final memos = <Memo>[
      Memo(rawText: '첫 메모 제목\n첫 메모 본문', dateTime: DateTime(2026, 10, 24, 9)),
      Memo(rawText: '둘 메모 제목\n둘 메모 본문', dateTime: DateTime(2026, 10, 25, 9)),
    ];
    final bloc = MemoBloc(
      _FakeMemoRepo(memos.map((memo) => memo.toMap()).toList()),
    );
    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MaterialApp(
          home: BlocProvider<MemoBloc>.value(
            value: bloc,
            child: const MemoView(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Memo'), findsOneWidget);
    expect(find.text('첫 메모 제목'), findsOneWidget);
    expect(find.text('첫 메모 본문'), findsOneWidget);
    expect(find.text('둘 메모 제목'), findsOneWidget);
    expect(find.text('둘 메모 본문'), findsOneWidget);
  });

  testWidgets('shows the empty view when no memos exist', (tester) async {
    final bloc = MemoBloc(_FakeMemoRepo(<Map<String, dynamic>>[]));
    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MaterialApp(
          home: BlocProvider<MemoBloc>.value(
            value: bloc,
            child: const MemoView(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Empty View'), findsOneWidget);
  });

  testWidgets('memo editor pops with the edited memo on save', (tester) async {
    Memo? popped;
    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return FButton(
                onPress: () {
                  unawaited(
                    Navigator.push(
                      context,
                      MemoEditorView.route(
                        Memo(rawText: '이전 제목\n이전 본문'),
                      ),
                    ).then((value) => popped = value),
                  );
                },
                child: const Text('open editor'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open editor'));
    await tester.pumpAndSettle();
    expect(find.text('Memo Edit View'), findsOneWidget);

    await tester.tap(find.byIcon(FLucideIcons.arrowLeft));
    await tester.pumpAndSettle();
    expect(popped, isNull);

    await tester.tap(find.text('open editor'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(FTextField), '새 제목\n새 본문');
    await tester.tap(find.byIcon(FLucideIcons.save));
    await tester.pumpAndSettle();

    expect(popped, isNotNull);
    expect(popped!.rawText, '새 제목\n새 본문');
  });
}

class _FakeMemoRepo extends MemoRepo {
  _FakeMemoRepo(this._memos);

  final List<Map<String, dynamic>> _memos;

  @override
  Stream<List<dynamic>> memoListStream() {
    return Stream<List<dynamic>>.value(_memos);
  }

  @override
  List<dynamic> loadMemoList() {
    return _memos;
  }

  @override
  Future<void> updateMemo({
    required String index,
    required Map<String, dynamic> data,
  }) async {
    _memos.add(data);
  }

  @override
  Future<void> removeMemo(String index) async {
    _memos.removeWhere((memo) => memo['index'] == index);
  }
}
