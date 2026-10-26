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
        style: FCalendarStyleDelta.delta(
          padding: const EdgeInsetsGeometryDelta.value(EdgeInsets.zero),
          dayPickerStyle: const FCalendarDayPickerStyleDelta.delta(
            // 44 matches forui's touch default: 7 cells fit the card at
            // 360dp without the grid overflowing the content width.
            daySize: Size(44, 44),
          ),
          headerStyle: FCalendarHeaderStyleDelta.delta(
            tappablePadding: const EdgeInsetsGeometryDelta.value(
              EdgeInsetsDirectional.only(
                start: 2,
                top: 4,
                bottom: 4,
              ),
            ),
            // The month/year labels default to the large display type; at
            // 360dp the two labels plus the arrows overflow the card, so
            // they are sized down to the body scale.
            headerTextStyle: FVariantsDelta.delta([
              FVariantOperation.all(const TextStyleDelta.delta(fontSize: 16)),
            ]),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: typography.body.lg,
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.bibleName} ${data.chapter}',
                  style: typography.body.sm,
                ),
                const SizedBox(height: 4),
                Text(data.summary),
                const SizedBox(height: 8),
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
