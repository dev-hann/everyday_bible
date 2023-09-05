import 'package:everydaybible/platform/desktop/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_content_view/quite_time_content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuiteTimeView extends StatefulWidget {
  const QuiteTimeView({super.key});

  @override
  State<QuiteTimeView> createState() => _QuiteTimeViewState();
}

class _QuiteTimeViewState extends State<QuiteTimeView>
    with AutomaticKeepAliveClientMixin {
  QuiteTimeBloc get bloc => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    bloc.add(const QuiteTimeEventInited());
  }

  AppBar appBar() {
    return AppBar();
  }

  Widget calendarWidget() {
    return const Text("Calendar");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        children: [
          calendarWidget(),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                QuiteTimeContentView.route(
                  context: context,
                  dateTime: DateTime.now(),
                ),
              );
            },
            icon: const Icon(Icons.new_label),
            label: const Text("Today QuiteTime"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
