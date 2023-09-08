import 'package:collection/collection.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/quite_time_view.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class QuiteTimeDashBoardView extends StatefulWidget {
  const QuiteTimeDashBoardView({super.key});

  @override
  State<QuiteTimeDashBoardView> createState() => _QuiteTimeDashBoardViewState();
}

class _QuiteTimeDashBoardViewState extends State<QuiteTimeDashBoardView>
    with AutomaticKeepAliveClientMixin {
  QuiteTimeDashBoardBloc get bloc => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    bloc.add(const QuiteTimeDashBoardEventInited());
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Quite Time"),
    );
  }

  Widget calendarWidget({
    required DateTime dateTime,
    required Function(DateTime dateTime) onChanged,
  }) {
    final now = DateTime.now();
    return Card(
      child: TableCalendar(
        availableGestures: AvailableGestures.horizontalSwipe,
        currentDay: dateTime,
        focusedDay: dateTime,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        firstDay: now.add(const Duration(days: -365)),
        lastDay: now,
        onDaySelected: (selectedDay, focusedDay) {
          onChanged(selectedDay);
        },
      ),
    );
  }

  Widget body({
    required QuiteTimeData? data,
  }) {
    if (data == null) {
      return const BibleLoading();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.dateTime.toString(),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              QuiteTimeView.route(
                context: context,
                data: data,
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "${data.bibleName} ${data.chapter}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(data.summary),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IgnorePointer(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("자세히 보기.."),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(),
      body: BlocBuilder<QuiteTimeDashBoardBloc, QuiteTimeDashBoardState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case QuiteTimeDashBoardViewStatus.init:
              return const BibleLoading();
            case QuiteTimeDashBoardViewStatus.loading:
            case QuiteTimeDashBoardViewStatus.failure:
            case QuiteTimeDashBoardViewStatus.success:
          }
          final dataList = state.dataList;
          final selectedDateTime = state.selectedDateTime;
          final selectedData = dataList.firstWhereOrNull(
            (element) => element.isSameDateTime(selectedDateTime),
          );
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              calendarWidget(
                dateTime: selectedDateTime,
                onChanged: (dateTime) {
                  bloc.add(
                    QuiteTimeDashBoardEventChangedDateTime(dateTime),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              body(
                data: selectedData,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
