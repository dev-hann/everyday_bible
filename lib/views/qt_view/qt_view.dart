import 'package:everydaybible/views/qt_view/bloc/qt_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QTView extends StatelessWidget {
  const QTView({super.key});

  Widget title(String title) {
    return Text(title);
  }

  Widget gospelList(Map<String, String> gospelData) {
    return Column(
      children: gospelData.entries.map((e) {
        return Text(e.key + e.value);
      }).toList(),
    );
  }

  Widget mediaPlayer(String url) {
    return SelectableText(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QTBloc, QTState>(
        builder: (context, state) {
          final status = state.status;
          switch (status) {
            case QTViewStatus.init:
            case QTViewStatus.loading:
            case QTViewStatus.fail:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case QTViewStatus.success:
          }
          final qt = state.qtData!;
          return ScaffoldPage.scrollable(
            bottomBar: mediaPlayer(qt.audioURL),
            children: [
              title(qt.title),
              gospelList(qt.gospelList),
            ],
          );
        },
      ),
    );
  }
}
