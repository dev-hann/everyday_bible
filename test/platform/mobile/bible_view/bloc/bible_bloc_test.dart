import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:everydaybible/platform/mobile/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBibleRepo extends Mock implements BibleRepo {}

void main() {
  group('BibleBloc', () {
    late _MockBibleRepo repo;

    setUp(() {
      repo = _MockBibleRepo();
    });

    // Raw `bible.json` style entry: Genesis with two single-verse chapters.
    MapEntry<String, dynamic> genesisEntry() {
      return const MapEntry<String, dynamic>(
        '0',
        <String, dynamic>{
          'name': '창세기',
          'chapterList': <Map<String, dynamic>>[
            <String, dynamic>{
              'verseList': <String>['태초에 하나님이 천지를 창조하시니라'],
            },
            <String, dynamic>{
              'verseList': <String>['이것이 천지의 창조의 내력이니라'],
            },
          ],
        },
      );
    }

    test('Inited seeds an empty database and opens chapter one', () async {
      final entry = genesisEntry();
      final data = BibleData.fromMapEntry(entry);
      when(() => repo.databaseIsEmpty()).thenReturn(true);
      when(() => repo.initDataBase()).thenAnswer((_) async {});
      when(() => repo.loadBibleDataList())
          .thenReturn(<MapEntry<String, dynamic>>[entry]);

      final bloc = BibleBloc(repo);
      final initial = bloc.state;
      final states = <BibleState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const BibleEventInited());
      await bloc.stream.firstWhere(
        (state) => state.status == BibleViewStatus.success,
      );
      await bloc.close();
      await sub.cancel();

      final loading = initial.copyWith(
        status: BibleViewStatus.loading,
        bibleDataList: <BibleData>[data],
      );
      expect(
        states,
        equals(
          <BibleState>[
            loading,
            loading.copyWith(
              status: BibleViewStatus.success,
              selectedData: data,
              selectedChapter: data.chapterList.first,
            ),
          ],
        ),
      );
      verify(() => repo.initDataBase()).called(1);
    });

    test('Inited skips seeding when the database already has data', () async {
      final entry = genesisEntry();
      final data = BibleData.fromMapEntry(entry);
      when(() => repo.databaseIsEmpty()).thenReturn(false);
      when(() => repo.loadBibleDataList())
          .thenReturn(<MapEntry<String, dynamic>>[entry]);

      final bloc = BibleBloc(repo);
      final initial = bloc.state;
      final states = <BibleState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const BibleEventInited());
      await bloc.stream.firstWhere(
        (state) => state.status == BibleViewStatus.success,
      );
      await bloc.close();
      await sub.cancel();

      final loading = initial.copyWith(
        status: BibleViewStatus.loading,
        bibleDataList: <BibleData>[data],
      );
      expect(
        states,
        equals(
          <BibleState>[
            loading,
            loading.copyWith(
              status: BibleViewStatus.success,
              selectedData: data,
              selectedChapter: data.chapterList.first,
            ),
          ],
        ),
      );
      verifyNever(() => repo.initDataBase());
    });

    test('UpdatedChapter selects the given book and chapter', () async {
      final data = BibleData.fromMapEntry(genesisEntry());
      final chapter = data.chapterList[1];

      final bloc = BibleBloc(repo);
      final initial = bloc.state;
      final states = <BibleState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(BibleEventUpdatedChapter(data, chapter));
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(
          <BibleState>[
            initial.copyWith(
              status: BibleViewStatus.success,
              selectedData: data,
              selectedChapter: chapter,
            ),
          ],
        ),
      );
    });

    test('OpenedDrawer has no registered handler and is rejected', () async {
      final bloc = BibleBloc(repo);
      final states = <BibleState>[];
      final sub = bloc.stream.listen(states.add);
      expect(
        () => bloc.add(BibleEventOpenedDrawer()),
        throwsStateError,
      );
      await bloc.close();
      await sub.cancel();
      expect(states, isEmpty);
    });
  });
}
