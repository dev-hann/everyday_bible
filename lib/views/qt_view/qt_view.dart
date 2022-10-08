import 'package:everydaybible/views/qt_player_view/bloc/qt_player_bloc.dart';
import 'package:everydaybible/views/qt_player_view/qt_player_viwe.dart';
import 'package:everydaybible/views/qt_view/bloc/qt_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QTView extends StatelessWidget {
  const QTView({super.key});

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

  Widget player() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: QTPlayerView(),
    );
  }

  List<Widget> body(Map<String, dynamic> gospelList) {
    return gospelList.entries.map((e) {
      return GospelText(index: e.key, text: e.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QTBloc, QTState>(
      listenWhen: (pre, curr) {
        return pre.status == QTViewStatus.init &&
            curr.status == QTViewStatus.success;
      },
      listener: (BuildContext context, state) {
        final qt = state.qtData!;
        final audioBloc = BlocProvider.of<QTPlayerBloc>(context);
        audioBloc.add(
          QTPlayerInited(title: qt.title, audioURL: qt.audioURL),
        );
      },
      child: BlocBuilder<QTBloc, QTState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case QTViewStatus.init:
            case QTViewStatus.loading:
            case QTViewStatus.fail:
              return const BibleLoading();
            case QTViewStatus.success:
          }
          // final bloc = BlocProvider.of<QTBloc>(context);
          final qt = state.qtData!;
          return ScaffoldPage.scrollable(
            header: headerWidget(),
            bottomBar: player(),
            children: body(qt.gospelList),
          );
        },
      ),
    );
  }
}
