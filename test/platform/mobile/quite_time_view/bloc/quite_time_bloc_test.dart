import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/model/quite_time/quite_time_gospel.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/repo/quite_time_repo/quite_time_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockQuiteTimeRepo extends Mock implements QuiteTimeRepo {}

void main() {
  group('QuiteTimeBloc', () {
    late _MockQuiteTimeRepo repo;

    setUp(() {
      repo = _MockQuiteTimeRepo();
    });

    final day = DateTime(2026, 1, 2, 8);
    final otherDay = DateTime(2026, 3, 5, 20);

    // Raw QT API payload of `day` (Genesis 22).
    Map<String, dynamic> dataMap() {
      return <String, dynamic>{
        'Qt_ty': 'QT1',
        'Base_de': '2026-01-02T00:00:00',
        'Bible_name': '창세기',
        'Bible_chapter': '22:1-19',
        'Qt_sj': '여호와 이레',
        'Qt_Brf': '아브라함을 시험하시니라',
      };
    }

    List<dynamic> bodyList() {
      return <dynamic>[
        <String, dynamic>{
          'Chapter': 22,
          'Verse': 1,
          'Bible_Cn': '그 일 후에 하나님이 아브라함을 시험하시려고',
        },
        <String, dynamic>{
          'Chapter': 22,
          'Verse': 2,
          'Bible_Cn': '여호와께서 이르시되 네 아들을 데리고',
        },
      ];
    }

    test('Inited loads the content of the given date', () async {
      when(() => repo.requestQuiteTimeData(day))
          .thenAnswer((_) async => dataMap());
      when(() => repo.requestQuiteTimeBody(day))
          .thenAnswer((_) async => bodyList());

      final bloc = QuiteTimeBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeEventInited(day));
      await bloc.stream.firstWhere(
        (state) => state.status == QuiteTimeViewStatus.success,
      );
      await bloc.close();
      await sub.cancel();

      expect(states, hasLength(2));
      expect(
        states[0],
        equals(
          initial.copyWith(
            status: QuiteTimeViewStatus.loading,
            dateTime: day,
          ),
        ),
      );
      final last = states[1];
      expect(last.status, QuiteTimeViewStatus.success);
      expect(last.dateTime, day);
      expect(last.quiteTime!.data, equals(QuiteTimeData.fromMap(dataMap())));
      expect(
        last.quiteTime!.gospelList,
        equals(
          bodyList()
              .map(
                (e) => QuiteTimeGospel.fromMap(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      verify(() => repo.requestQuiteTimeData(day)).called(1);
      verify(() => repo.requestQuiteTimeBody(day)).called(1);
    });

    test('UpdatedDateTime keeps the last content while a new date fails',
        () async {
      when(() => repo.requestQuiteTimeData(day))
          .thenAnswer((_) async => dataMap());
      when(() => repo.requestQuiteTimeBody(day))
          .thenAnswer((_) async => bodyList());
      when(() => repo.requestQuiteTimeData(otherDay))
          .thenThrow(Exception('network down'));

      final bloc = QuiteTimeBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeEventUpdatedDateTime(day));
      await pumpEventQueue();
      bloc.add(QuiteTimeEventUpdatedDateTime(otherDay));
      await bloc.close();
      await sub.cancel();

      expect(states, hasLength(3));
      expect(
        states[0],
        equals(
          initial.copyWith(
            status: QuiteTimeViewStatus.loading,
            dateTime: day,
          ),
        ),
      );
      expect(states[1].status, QuiteTimeViewStatus.success);
      expect(
        states[2],
        equals(
          states[1].copyWith(
            status: QuiteTimeViewStatus.loading,
            dateTime: otherDay,
          ),
        ),
      );
      // The failed reload keeps showing the previously loaded day.
      expect(identical(states[2].quiteTime, states[1].quiteTime), isTrue);
    });

    test('UpdatedDateTime emits only the loading state when the fetch fails',
        () async {
      when(() => repo.requestQuiteTimeData(any<DateTime>()))
          .thenThrow(Exception('offline'));

      final bloc = QuiteTimeBloc(repo);
      final initial = bloc.state;
      final states = <QuiteTimeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(QuiteTimeEventUpdatedDateTime(day));
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(
          <QuiteTimeState>[
            initial.copyWith(
              status: QuiteTimeViewStatus.loading,
              dateTime: day,
            ),
          ],
        ),
      );
    });
  });
}
