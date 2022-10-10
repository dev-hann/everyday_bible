import 'package:everydaybible/views/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BibleView extends StatelessWidget {
  const BibleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case BibleViewStatus.init:
          case BibleViewStatus.loading:
          case BibleViewStatus.fail:
            return const BibleLoading();
          case BibleViewStatus.success:
        }
        final bloc = BlocProvider.of<BibleBloc>(context);
        return TabView(
          currentIndex: state.tabIndex,
          closeButtonVisibility: CloseButtonVisibilityMode.never,
          showScrollButtons: false,
          onChanged: (index) {
            bloc.add(BibleOnTapTab(index));
          },
          tabs: [
            Tab(
              text: Text("구약성경"),
              body: Text("Hello"),
            ),
            Tab(
              text: Text("신약성경"),
              body: Text("!!@j"),
            ),
          ],
        );
      },
    );
  }
}
