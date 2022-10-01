import 'package:everydaybible/views/qt_view/bloc/qt_bloc.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QTView extends StatelessWidget {
  const QTView({super.key});

  Widget header(String title) {
    Widget titleText() {
      return Row(
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
        Expanded(child: titleText()),
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

  Widget gospelList(Map<String, String> gospelData) {
    return Column(
      children: gospelData.entries.map((e) {
        return GospelText(
          index: e.key,
          text: e.value,
        );
      }).toList(),
    );
  }

  Widget mediaPlayer(String url) {
    return SelectableText(url);
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
            child: header(qt.title),
          ),
          bottomBar: mediaPlayer(qt.audioURL),
          children: [
            gospelList(qt.gospelList),
          ],
        );
      },
    );
  }
}
