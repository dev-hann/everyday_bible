import 'package:everydaybible/platform/desktop/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  BibleBloc get bloc => BlocProvider.of(context);
  @override
  void initState() {
    super.initState();
    bloc.add(BibleEventInited());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleBloc, BibleState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case BibleViewStatus.init:
            return const BibleLoading();
          case BibleViewStatus.loading:
          case BibleViewStatus.failure:
          case BibleViewStatus.success:
        }
        return ScaffoldPage.scrollable(
          header: Text("Title"),
          children: [],
        );
      },
    );
  }
}
