import 'package:everydaybible/platform/desktop/audio_player_view/audio_player_view.dart';
import 'package:everydaybible/platform/desktop/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/platform/desktop/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/gospel_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuiteTimeView extends StatefulWidget {
  const QuiteTimeView({super.key});

  @override
  State<QuiteTimeView> createState() => _QuiteTimeViewState();
}

class _QuiteTimeViewState extends State<QuiteTimeView> {
  QuiteTimeBloc get bloc => BlocProvider.of(context);
  AudioPlayerBloc get audioBloc => BlocProvider.of(context);

  Widget headerWidget({
    required String title,
    required String subTitle,
  }) {
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
              FluentIcons.calendar,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FluentIcons.bookmarks,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget player() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: AudioPlayerView(),
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
        final data = quiteTime.data;
        return ScaffoldPage.scrollable(
          header: headerWidget(
            title: data.title,
            subTitle: data.summary,
          ),
          bottomBar: player(),
          children: quiteTime.gospelList.map((item) {
            return VerseText(
              index: item.verse,
              text: item.gospel,
            );
          }).toList(),
        );
      },
    );
  }
}
