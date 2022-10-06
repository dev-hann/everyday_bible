import 'package:everydaybible/models/quite_time_audio.dart';
import 'package:everydaybible/views/qt_view/bloc/qt_bloc.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:everydaybible/widgets/qt_player.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QTView extends StatelessWidget {
  const QTView({super.key});

  Widget audioPlayer(
    QuiteTimeAudio audio, {
    required Function(double value) onChangedDuration,
    required VoidCallback onTapPlay,
  }) {
    return QTPlayer(
      isPlaying: audio.isPlaying,
      title: audio.title,
      onTapPlay: onTapPlay,
      currentDuration: audio.currentDuration,
      totalDuration: audio.totalDuration,
      onChangedDuration: onChangedDuration,
    );
  }

  Widget headerWidget() {
    return BlocBuilder<QTBloc, QTState>(
      builder: (context, state) {
        final data = state.qtData!;
        final title = data.title;
        final subTitle = data.subTitle;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
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
                    ),
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
          ),
        );
      },
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
        final bloc = BlocProvider.of<QTBloc>(context);
        final qt = state.qtData!;
        return ScaffoldPage.scrollable(
          header: headerWidget(),
          bottomBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: audioPlayer(
              state.audio,
              onChangedDuration: (double value) {
                bloc.add(QTOnChangedDuration(value));
              },
              onTapPlay: () {
                bloc.add(QTOnTapPlay());
              },
            ),
          ),
          children: qt.gospelList.entries.map((e) {
            return GospelText(index: e.key, text: e.value);
          }).toList(),
        );
      },
    );
  }
}
