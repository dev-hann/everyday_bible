import 'package:everydaybible/model/quite_time/quite_time_data.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/audio_player_view.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen Quiet Time reader for one day: title, gospel verses, and
/// the meditation audio player bar.
class QuiteTimeView extends StatefulWidget {
  /// Creates the reader for the given [data].
  const QuiteTimeView({
    required this.data,
    super.key,
  });

  /// The day's Quiet Time data shown by this reader.
  final QuiteTimeData data;

  /// Returns the route that opens the reader for [data], providing the
  /// blocs it needs.
  static PageRoute<void> route({
    required BuildContext context,
    required QuiteTimeData data,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) {
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
      },
    );
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
      title: const Text('QuiteTimeContent'),
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
                  left: 16,
                  right: 16,
                  top: 16,
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
                  const SizedBox(height: 16),
                  for (final item in quiteTime.gospelList)
                    VerseText(
                      index: item.verse,
                      text: item.gospel,
                    ),
                ],
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
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
