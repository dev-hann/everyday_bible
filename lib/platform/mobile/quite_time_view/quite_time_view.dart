import 'package:everydaybible/platform/mobile/audio_player_view/audio_player_view.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuiteTimeView extends StatefulWidget {
  const QuiteTimeView({super.key});

  @override
  State<QuiteTimeView> createState() => _QuiteTimeViewState();
}

class _QuiteTimeViewState extends State<QuiteTimeView> {
  QuiteTimeBloc get bloc => BlocProvider.of(context);

  AppBar appBar() {
    return AppBar(
      title: const Text("QuiteTime"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuiteTimeBloc, QuiteTimeState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case QuiteTimeViewStatus.init:
          case QuiteTimeViewStatus.loading:
            return const BibleLoading();
          case QuiteTimeViewStatus.failure:
          case QuiteTimeViewStatus.success:
        }
        final quiteTime = state.quiteTime!;

        return Scaffold(
          appBar: appBar(),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(
                  bottom: kToolbarHeight * 2,
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      quiteTime.data.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  for (final item in quiteTime.gospelList)
                    VerseText(
                      index: item.verse,
                      text: item.gospel,
                    )
                ],
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AudioPlayerView(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
