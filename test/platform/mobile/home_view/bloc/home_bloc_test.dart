import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeBloc', () {
    test('Inited marks the view ready', () async {
      final bloc = HomeBloc();
      final initial = bloc.state;
      final states = <HomeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const HomeEventInited());
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(
          <HomeState>[initial.copyWith(status: HomeViewStatus.success)],
        ),
      );
    });

    test('UpdatedIndex switches the selected tab', () async {
      final bloc = HomeBloc();
      final initial = bloc.state;
      final states = <HomeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const HomeEventUpdatedIndex(2));
      await bloc.close();
      await sub.cancel();

      expect(
        states,
        equals(
          <HomeState>[
            initial.copyWith(
              status: HomeViewStatus.success,
              menuIndex: 2,
            ),
          ],
        ),
      );
    });

    test('switching to the current tab keeps the state unchanged', () async {
      final bloc = HomeBloc();
      final states = <HomeState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const HomeEventInited());
      await pumpEventQueue();
      // menuIndex 0 is already selected; only the status transition emits.
      bloc.add(const HomeEventUpdatedIndex(0));
      await bloc.close();
      await sub.cancel();

      expect(states, hasLength(1));
      expect(states.single.status, HomeViewStatus.success);
      expect(states.single.menuIndex, 0);
    });
  });
}
