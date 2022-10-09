import 'package:everydaybible/enum/audio_state.dart';
import 'package:everydaybible/models/quite_time_format.dart';
import 'package:everydaybible/views/qt_player_view/bloc/qt_player_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QTPlayerView extends StatelessWidget {
  const QTPlayerView({super.key});

  Widget stateIcon({
    required VoidCallback onTapPlay,
    required bool isPlaying,
    required AudioState state,
  }) {
    switch (state) {
      case AudioState.loading:
      case AudioState.buffering:
        return const BibleLoading();
      case AudioState.idle:
      case AudioState.ready:
      case AudioState.completed:
    }
    return IconButton(
      onPressed: onTapPlay,
      icon: Icon(!isPlaying ? FluentIcons.play : FluentIcons.pause),
    );
  }

  Widget titleText(String title) {
    return Text(title);
  }

  Widget soundController() {
    void showSlider(BuildContext context) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero);
      const w = 50.0;
      const h = 200.0;
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        builder: (context) {
          return Stack(
            children: [
              Positioned.fromRect(
                rect: Rect.fromLTWH(
                  offset.dx + (w / 4),
                  offset.dy - h,
                  w,
                  h,
                ),
                child: Card(
                  child: Column(
                    children: [
                      Icon(FluentIcons.volume3),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: Slider(
                            onChanged: (value) {},
                            value: 0.5,
                            max: 1,
                            vertical: true,
                          ),
                        ),
                      ),
                      Icon(FluentIcons.volume0),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Builder(builder: (context) {
      return IconButton(
        onPressed: () {
          showSlider(context);
        },
        icon: const Icon(FluentIcons.volume_disabled),
      );
    });
  }

  Widget progressBar({
    required Duration position,
    required Duration duration,
    required Function(double value) onChangeStart,
    required Function(double value) onChangeEnd,
    required Function(double value) onChange,
  }) {
    return Slider(
      value: position.inMilliseconds.toDouble(),
      max: duration.inMilliseconds.toDouble(),
      onChangeStart: onChangeStart,
      onChanged: onChange,
      onChangeEnd: onChangeEnd,
    );
  }

  Widget durationText({
    required Duration position,
    required Duration duration,
  }) {
    final current = QuiteTimeFormat.duration(position);
    final total = QuiteTimeFormat.duration(duration);
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        // fontSize: durationTextNotifier.value ? 15 : 14,
        color: Colors.black,
      ),
      child: Text("$current / $total"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocBuilder<QTPlayerBloc, QTPlayerState>(
          builder: (context, state) {
            final status = state.status;
            switch (status) {
              case QTPlayerViewStatus.init:
              case QTPlayerViewStatus.loading:
                return const BibleLoading();
              case QTPlayerViewStatus.fail:
              case QTPlayerViewStatus.success:
            }
            final bloc = BlocProvider.of<QTPlayerBloc>(context);
            final audio = state.audio;
            final position = audio.position;
            final duration = audio.duration;
            return Row(
              children: [
                stateIcon(
                  onTapPlay: () {
                    bloc.add(QTPlayerOnTapPlay());
                  },
                  isPlaying: audio.isPlaying,
                  state: audio.state,
                ),
                const SizedBox(width: 16.0),
                titleText(audio.title),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: progressBar(
                          position: position,
                          duration: duration,
                          onChangeStart: (value) {
                            bloc.add(QTPlayerOnChangeDurationStart(value));
                          },
                          onChange: (value) {
                            bloc.add(QTPlayerOnChangeDuration(value));
                          },
                          onChangeEnd: (value) {
                            bloc.add(QTPlayerOnChangeDurationEnd(value));
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      durationText(
                        position: position,
                        duration: duration,
                      ),
                      soundController(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
