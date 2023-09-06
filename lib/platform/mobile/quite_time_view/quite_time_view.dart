import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/quite_time_content_view/quite_time_content_view.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:collection/collection.dart';

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
              QuiteTimeContentView.route(
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
      body: BlocBuilder<QuiteTimeBloc, QuiteTimeState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case QuiteTimeViewStatus.init:
              return const BibleLoading();
            case QuiteTimeViewStatus.loading:
            case QuiteTimeViewStatus.failure:
            case QuiteTimeViewStatus.success:
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
                    QuiteTimeEventChangedDateTime(dateTime),
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
