import 'dart:async';

import 'package:everydaybible/model/memo/memo.dart';
import 'package:everydaybible/platform/mobile/memo_view/bloc/memo_bloc.dart';
import 'package:everydaybible/repo/memo_repo/memo_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockMemoRepo extends Mock implements MemoRepo {}

void main() {
  group('MemoBloc', () {
    late _MockMemoRepo repo;

    setUp(() {
      repo = _MockMemoRepo();
    });

    final firstMemo = Memo(
      rawText: '첫 메모 제목\n첫 메모 본문',
      dateTime: DateTime(2026, 1, 2, 9, 30),
    );
    final secondMemo = Memo(
      rawText: '둘째 메모 제목\n둘째 메모 본문',
      dateTime: DateTime(2026, 3, 5, 20),
    );

    test('Inited loads the cached list and follows table changes', () async {
      final controller = StreamController<List<dynamic>>.broadcast();
      when(() => repo.loadMemoList()).thenReturn(<dynamic>[firstMemo.toMap()]);
      when(() => repo.memoListStream()).thenAnswer((_) => controller.stream);

      final bloc = MemoBloc(repo);
      final initial = bloc.state;
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const MemoEventInited());
      await pumpEventQueue();
      controller.add(<dynamic>[firstMemo.toMap(), secondMemo.toMap()]);
      await pumpEventQueue();
      await bloc.close();
      await sub.cancel();
      await controller.close();

      final loaded = initial.copyWith(
        status: MemoViewStatus.success,
        memoList: <Memo>[firstMemo],
      );
      expect(
        states,
        equals(
          <MemoState>[
            loaded,
            loaded.copyWith(memoList: <Memo>[firstMemo, secondMemo]),
          ],
        ),
      );
    });

    test('Inited ignores a failing cache load but still follows changes',
        () async {
      final controller = StreamController<List<dynamic>>.broadcast();
      when(() => repo.loadMemoList()).thenThrow(Exception('corrupt cache'));
      when(() => repo.memoListStream()).thenAnswer((_) => controller.stream);

      final bloc = MemoBloc(repo);
      final initial = bloc.state;
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const MemoEventInited());
      await pumpEventQueue();
      controller.add(<dynamic>[secondMemo.toMap()]);
      await pumpEventQueue();
      await bloc.close();
      await sub.cancel();
      await controller.close();

      expect(
        states,
        equals(
          <MemoState>[
            initial.copyWith(
              status: MemoViewStatus.success,
              memoList: <Memo>[secondMemo],
            ),
          ],
        ),
      );
    });

    test('UpdatedMemo selects the saved memo on success', () async {
      when(
        () => repo.updateMemo(
          index: firstMemo.index,
          data: firstMemo.toMap(),
        ),
      ).thenAnswer((_) async {});

      final bloc = MemoBloc(repo);
      final initial = bloc.state;
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(MemoEventUpdatedMemo(firstMemo));
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(<MemoState>[initial.copyWith(selectedMemo: firstMemo)]),
      );
      verify(
        () => repo.updateMemo(
          index: firstMemo.index,
          data: firstMemo.toMap(),
        ),
      ).called(1);
    });

    test('UpdatedMemo emits nothing when the write fails', () async {
      when(
        () => repo.updateMemo(
          index: firstMemo.index,
          data: firstMemo.toMap(),
        ),
      ).thenThrow(Exception('db locked'));

      final bloc = MemoBloc(repo);
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(MemoEventUpdatedMemo(firstMemo));
      await bloc.close();
      await sub.cancel();

      expect(states, isEmpty);
      verify(
        () => repo.updateMemo(
          index: firstMemo.index,
          data: firstMemo.toMap(),
        ),
      ).called(1);
    });

    test('RemovedMemo deletes the memo without changing the state', () async {
      when(() => repo.removeMemo(firstMemo.index)).thenAnswer((_) async {});

      final bloc = MemoBloc(repo);
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(MemoEventRemovedMemo(firstMemo));
      await bloc.close();
      await sub.cancel();

      expect(states, isEmpty);
      verify(() => repo.removeMemo(firstMemo.index)).called(1);
    });

    test('RemovedMemo emits nothing when the delete fails', () async {
      when(() => repo.removeMemo(firstMemo.index))
          .thenThrow(Exception('db locked'));

      final bloc = MemoBloc(repo);
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(MemoEventRemovedMemo(firstMemo));
      await bloc.close();
      await sub.cancel();

      expect(states, isEmpty);
      verify(() => repo.removeMemo(firstMemo.index)).called(1);
    });

    test('UpdatedMemo persists while the change stream refreshes the list',
        () async {
      final controller = StreamController<List<dynamic>>.broadcast();
      when(() => repo.loadMemoList()).thenReturn(<dynamic>[]);
      when(() => repo.memoListStream()).thenAnswer((_) => controller.stream);
      when(
        () => repo.updateMemo(
          index: firstMemo.index,
          data: firstMemo.toMap(),
        ),
      ).thenAnswer((_) async {});

      final bloc = MemoBloc(repo);
      final initial = bloc.state;
      final states = <MemoState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const MemoEventInited());
      await pumpEventQueue();
      bloc.add(MemoEventUpdatedMemo(firstMemo));
      await pumpEventQueue();
      controller.add(<dynamic>[firstMemo.toMap()]);
      await pumpEventQueue();
      await bloc.close();
      await sub.cancel();
      await controller.close();

      final empty = initial.copyWith(
        status: MemoViewStatus.success,
        memoList: const <Memo>[],
      );
      expect(
        states,
        equals(
          <MemoState>[
            empty,
            empty.copyWith(selectedMemo: firstMemo),
            empty.copyWith(
              selectedMemo: firstMemo,
              memoList: <Memo>[firstMemo],
            ),
          ],
        ),
      );
    });
  });
}
