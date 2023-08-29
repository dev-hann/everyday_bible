import 'package:everydaybible/platform/desktop/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuiteTimeView extends StatefulWidget {
  const QuiteTimeView({super.key});

  @override
  State<QuiteTimeView> createState() => _QuiteTimeViewState();
}

class _QuiteTimeViewState extends State<QuiteTimeView> {
  QuiteTimeBloc get bloc => BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    return Text("QuiteTime View");
  }
}
