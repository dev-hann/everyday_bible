import 'package:collection/collection.dart';
import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/bloc/quite_time_dash_board_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/quite_time_view.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

/// Quiet Time tab: a calendar for picking a date and a summary card that
/// opens the reader for that day.
class QuiteTimeDashBoardView extends StatefulWidget {
  /// Creates the dashboard view.
  const QuiteTimeDashBoardView({super.key});

  @override
  State<QuiteTimeDashBoardView> createState() => _QuiteTimeDashBoardViewState();
}

class _QuiteTimeDashBoardViewState extends State<QuiteTimeDashBoardView>
    with AutomaticKeepAliveClientMixin {
  QuiteTimeDashBoardBloc get bloc => BlocProvider.of(context);

  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    bloc.add(const QuiteTimeDashBoardEventInited());
  }

  Widget calendarWidget({
    required DateTime dateTime,
    required void Function(DateTime dateTime) onChanged,
  }) {
    return FCard(
      // The grid calendar is a fixed 7 day-cells wide; a slimmer card
      // padding keeps it inside a phone's content width.
      style: const FCardStyleDelta.delta(
        padding: EdgeInsetsGeometryDelta.value(EdgeInsets.all(8)),
      ),
      child: FCalendar.grid(
        control: FGridCalendarControl(
          start: now.add(const Duration(days: -365)),
          end: now,
          today: now,
          initial: dateTime,
        ),
        style: const FCalendarStyleDelta.delta(
          padding: EdgeInsetsGeometryDelta.value(EdgeInsets.zero),
          dayPickerStyle: FCalendarDayPickerStyleDelta.delta(
            daySize: Size(48, 44),
          ),
          headerStyle: FCalendarHeaderStyleDelta.delta(
            tappablePadding: EdgeInsetsGeometryDelta.value(
              EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        ),
        selectionControl: FDateSelectionControl.liftedSingle(
          value: dateTime,
          toggleable: false,
          onChange: (date) {
            if (date != null) {
              onChanged(date);
            }
          },
        ),
      ),
    );
  }

  Widget body({
    required QuiteTimeData? data,
  }) {
    if (data == null) {
      return const BibleLoading();
    }
    final typography = context.theme.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.dateTime.toString(),
        ),
        const SizedBox(height: 16),
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
          child: FCard(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    data.title,
                    style: typography.body.lg,
                  ),
                  Text(
                    '${data.bibleName} ${data.chapter}',
                    style: typography.body.sm,
                  ),
                  Text(data.summary),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '자세히 보기..',
                      style: TextStyle(color: context.theme.colors.primary),
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
    return FScaffold(
      header: const FHeader(title: Text('Quite Time')),
      child: BlocBuilder<QuiteTimeDashBoardBloc, QuiteTimeDashBoardState>(
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
            padding: const EdgeInsets.all(16),
            children: [
              calendarWidget(
                dateTime: selectedDateTime,
                onChanged: (dateTime) {
                  bloc.add(
                    QuiteTimeDashBoardEventChangedDateTime(dateTime),
                  );
                },
              ),
              const SizedBox(height: 16),
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
