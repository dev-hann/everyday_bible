import 'package:everydaybible/models/quite_time_audio.dart';
import 'package:everydaybible/views/qt_view/bloc/qt_bloc.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:everydaybible/widgets/qt_player.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QTView extends StatelessWidget {
  const QTView({super.key});

  Widget header({
    required String title,
    required String subTitle,
  }) {
    Widget titleText() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(FluentIcons.page_left),
            onPressed: () {},
          ),
          Text(title),
          IconButton(
            icon: const Icon(FluentIcons.page_right),
            onPressed: () {},
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              titleText(),
              Text(subTitle),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.calendar,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.bookmark,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget mediaPlayer(QuiteTimeAudio audio) {
    return QTPlayer(
      isPlaying: audio.isPlaying,
      title: audio.title,
      currentDuration: audio.currentDuration,
      totalDuration: audio.totalDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QTBloc, QTState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case QTViewStatus.init:
          case QTViewStatus.loading:
          case QTViewStatus.fail:
            return const Center(
              child: NavigationIndicator(),
            );
          case QTViewStatus.success:
        }
        final qt = state.qtData!;
        return ScaffoldPage.scrollable(
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: header(
              title: qt.title,
              subTitle: qt.subTitle,
            ),
          ),
          bottomBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: mediaPlayer(state.audio),
          ),
          children: qt.gospelList.entries.map((e) {
            return GospelText(
              index: e.key,
              text: e.value,
            );
          }).toList(),
        );
      },
    );
  }
}
