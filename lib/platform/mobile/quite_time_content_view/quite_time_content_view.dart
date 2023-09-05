import 'package:everydaybible/platform/mobile/audio_player_view/audio_player_view.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_content_view/bloc/quite_time_content_bloc.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuiteTimeContentView extends StatefulWidget {
  const QuiteTimeContentView({
    super.key,
    required this.dateTime,
  });

  final DateTime dateTime;

  static PageRoute route({
    required BuildContext context,
    required DateTime dateTime,
  }) {
    return MaterialPageRoute(builder: (_) {
      return BlocProvider(
        create: (_) => QuiteTimeContentBloc(Repo.of(context)),
        child: QuiteTimeContentView(
          dateTime: dateTime,
        ),
      );
    });
  }

  @override
  State<QuiteTimeContentView> createState() => _QuiteTimeContentViewState();
}

class _QuiteTimeContentViewState extends State<QuiteTimeContentView> {
  QuiteTimeContentBloc get bloc => BlocProvider.of(context);
  AudioPlayerBloc get audioBloc => BlocProvider.of(context);
  @override
  void initState() {
    super.initState();
    final dateTime = widget.dateTime;
    bloc.add(
      QuiteTimeContentEventInited(dateTime),
    );
    audioBloc.add(
      AudioPlayerEventInited(dateTime),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("QuiteTimeContent"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuiteTimeContentBloc, QuiteTimeContentState>(
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
