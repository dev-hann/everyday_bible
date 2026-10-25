import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/quite_time_dash_board_view.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  Future<void> pumpView(
    WidgetTester tester,
    QuiteTimeDashBoardBloc bloc,
  ) async {
    await tester.pumpWidget(
      FTheme(
        data: FTheme.neutral.light.touch,
        child: MaterialApp(
          home: BlocProvider<QuiteTimeDashBoardBloc>.value(
            value: bloc,
            child: const QuiteTimeDashBoardView(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the calendar and the selected day summary', (
    tester,
  ) async {
    final bloc = QuiteTimeDashBoardBloc(_FakeQuiteTimeRepo());
    await pumpView(tester, bloc);

    final now = DateTime.now();
    expect(find.text('Quite Time'), findsOneWidget);
    expect(find.byType(FCalendar), findsOneWidget);
    expect(find.text('묵상 제목 ${now.month}-${now.day}'), findsOneWidget);
    expect(find.text('창세기 1장'), findsOneWidget);
    expect(find.text('자세히 보기..'), findsOneWidget);
  });

  testWidgets('tapping a calendar day loads that day summary', (
    tester,
  ) async {
    final bloc = QuiteTimeDashBoardBloc(_FakeQuiteTimeRepo());
    await pumpView(tester, bloc);

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    expect(bloc.state.selectedDateTime.day, 15);
    expect(find.text('묵상 제목 ${now.month}-15'), findsOneWidget);
  });
}

class _FakeQuiteTimeRepo extends QuiteTimeRepo {
  @override
  Future<dynamic> requestQuiteTimeData(DateTime dateTime) async {
    return <String, dynamic>{
      'Qt_ty': 'QT1',
      'Base_de': _format(dateTime),
      'Bible_name': '창세기',
      'Bible_chapter': '1장',
      'Qt_sj': '묵상 제목 ${dateTime.month}-${dateTime.day}',
      'Qt_Brf': '묵상 요약 ${dateTime.month}-${dateTime.day}',
    };
  }

  @override
  Future<dynamic> requestQuiteTimeBody(DateTime dateTime) async {
    return <Map<String, dynamic>>[
      <String, dynamic>{
        'Chapter': 1,
        'Verse': 1,
        'Bible_Cn': '태초에 하나님이 천지를 창조하시니라',
      },
    ];
  }

  String _format(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-'
        '${twoDigits(dateTime.day)}';
  }
}
