import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/audio_player_view.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuiteTimeView extends StatefulWidget {
  const QuiteTimeView({
    super.key,
    required this.data,
  });

  final QuiteTimeData data;

  static PageRoute route({
    required BuildContext context,
    required QuiteTimeData data,
  }) {
    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => QuiteTimeBloc(Repo.of(context)),
          ),
          BlocProvider<AudioPlayerBloc>.value(
            value: BlocProvider.of(context),
          ),
        ],
        child: QuiteTimeView(data: data),
      );
    });
  }

  @override
  State<QuiteTimeView> createState() => _QuiteTimeViewState();
}

class _QuiteTimeViewState extends State<QuiteTimeView> {
  QuiteTimeBloc get bloc => BlocProvider.of(context);
  AudioPlayerBloc get audioBloc => BlocProvider.of(context);
  @override
  void initState() {
    super.initState();
    final dateTime = widget.data.dateTime;
    bloc.add(
      QuiteTimeEventInited(dateTime),
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
