import 'package:everydaybible/platform/desktop/bible_view/bloc/bible_bloc.dart';
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
  Widget build(BuildContext context) {
    return const Text("Bible View");
  }
}
