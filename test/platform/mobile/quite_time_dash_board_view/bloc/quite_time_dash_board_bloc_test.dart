import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockQuiteTimeRepo extends Mock implements QuiteTimeRepo {}

void main() {
  group('QuiteTimeDashBoardBloc', () {
    late _MockQuiteTimeRepo repo;

    setUp(() {
      repo = _MockQuiteTimeRepo();
    });

    final day = DateTime(2026, 1, 2, 8);
    final dayLater = DateTime(2026, 1, 2, 22);
    final otherDay = DateTime(2026, 3, 5, 20);

    Map<String, dynamic> dataMap(String baseDe) {
      return <String, dynamic>{
        'Qt_ty': 'QT1',
        'Base_de': baseDe,
        'Bible_name': '창세기',
        'Bible_chapter': '22:1-19',
        'Qt_sj': '여호와 이레',
        'Qt_Brf': '아브라함을 시험하시니라',
      };
    }

    test('Inited marks the dashboard ready and fetches the selected date',
        () async {
      // Echo the requested date so the data is treated as already loaded.
      when(() => repo.requestQuiteTimeData(any<DateTime>())).thenAnswer(
        (invocation) async => dataMap(
          (invocation.positionalArguments.first as DateTime)
              .toIso8601String(),
        ),
      );

      final bloc = QuiteTimeDashBoardBloc(repo);
      final states = <QuiteTimeDashBoardState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const QuiteTimeDashBoardEventInited());
      await bloc.stream.firstWhere(
        (state) => state.status == QuiteTimeDashBoardViewStatus.success,
      );
      await bloc.close();
      await sub.cancel();

      expect(
        states.first.status,
        QuiteTimeDashBoardViewStatus.success,
      );
      // Inited chains ChangedDateTime(selected day): the day is not cached
      // yet, so it is fetched once and appended to the data list.
      expect(states.last.dataList, hasLength(1));
      verify(() => repo.requestQuiteTimeData(any<DateTime>())).called(1);
    });

    test('ChangedDateTime fetches and stores the data of a new date', () async {
      when(() => repo.requestQuiteTimeData(day))
          .thenAnswer((_) async => dataMap('2026-01-02T00:00:00'));
      final expected = QuiteTimeData.fromMap(dataMap('2026-01-02T00:00:00'));

      final bloc = QuiteTimeDashBoardBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeDashBoardState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeDashBoardEventChangedDateTime(day));
      await bloc.close();
      await sub.cancel();

      final selected = initial.copyWith(selectedDateTime: day);
      expect(
        states,
        equals(
          <QuiteTimeDashBoardState>[
            selected,
            selected.copyWith(dataList: <QuiteTimeData>[expected]),
          ],
        ),
      );
      verify(() => repo.requestQuiteTimeData(day)).called(1);
    });

    test('ChangedDateTime skips the fetch for an already loaded day', () async {
      when(() => repo.requestQuiteTimeData(any<DateTime>()))
          .thenAnswer((_) async => dataMap('2026-01-02T00:00:00'));
      final expected = QuiteTimeData.fromMap(dataMap('2026-01-02T00:00:00'));

      final bloc = QuiteTimeDashBoardBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeDashBoardState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeDashBoardEventChangedDateTime(day));
      await pumpEventQueue();
      bloc.add(QuiteTimeDashBoardEventChangedDateTime(dayLater));
      await bloc.close();
      await sub.cancel();

      final withData = initial.copyWith(selectedDateTime: day).copyWith(
        dataList: <QuiteTimeData>[expected],
      );
      expect(
        states,
        equals(
          <QuiteTimeDashBoardState>[
            initial.copyWith(selectedDateTime: day),
            withData,
            withData.copyWith(selectedDateTime: dayLater),
          ],
        ),
      );
      verify(() => repo.requestQuiteTimeData(any<DateTime>())).called(1);
    });

    test('ChangedDateTime appends the data of each distinct day', () async {
      final firstData = QuiteTimeData.fromMap(dataMap('2026-01-02T00:00:00'));
      final secondData = QuiteTimeData.fromMap(dataMap('2026-03-05T00:00:00'));
      when(() => repo.requestQuiteTimeData(day))
          .thenAnswer((_) async => dataMap('2026-01-02T00:00:00'));
      when(() => repo.requestQuiteTimeData(otherDay))
          .thenAnswer((_) async => dataMap('2026-03-05T00:00:00'));

      final bloc = QuiteTimeDashBoardBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeDashBoardState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeDashBoardEventChangedDateTime(day));
      await pumpEventQueue();
      bloc.add(QuiteTimeDashBoardEventChangedDateTime(otherDay));
      await bloc.close();
      await sub.cancel();

      final firstDay = initial.copyWith(selectedDateTime: day).copyWith(
        dataList: <QuiteTimeData>[firstData],
      );
      expect(
        states,
        equals(
          <QuiteTimeDashBoardState>[
            initial.copyWith(selectedDateTime: day),
            firstDay,
            firstDay.copyWith(selectedDateTime: otherDay),
            firstDay.copyWith(
              selectedDateTime: otherDay,
              dataList: <QuiteTimeData>[firstData, secondData],
            ),
          ],
        ),
      );
    });

    test('ChangedDateTime keeps the list unchanged when the fetch fails',
        () async {
      when(() => repo.requestQuiteTimeData(any<DateTime>()))
          .thenThrow(Exception('offline'));

      final bloc = QuiteTimeDashBoardBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeDashBoardState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeDashBoardEventChangedDateTime(day));
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(
          <QuiteTimeDashBoardState>[
            initial.copyWith(selectedDateTime: day),
          ],
        ),
      );
    });
  });
}
