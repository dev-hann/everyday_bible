import 'package:everydaybible/platform/desktop/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  AudioPlayerBloc get bloc => BlocProvider.of(context);

  Widget stateIcon({
    required VoidCallback onTapPlay,
    required bool isPlaying,
    required ProcessingState processingState,
  }) {
    switch (processingState) {
      case ProcessingState.buffering:
      case ProcessingState.loading:
        return const BibleLoading();
      case ProcessingState.idle:
      case ProcessingState.ready:
      case ProcessingState.completed:
    }
    return IconButton(
      onPressed: onTapPlay,
      icon: Icon(!isPlaying ? FluentIcons.play : FluentIcons.pause),
    );
  }

  void showSlider(
    BuildContext context, {
    required double initValue,
    required Function(double volume) onChanged,
  }) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    const w = 50.0;
    const h = 200.0;
    final ValueNotifier<double> volumeNotifier = ValueNotifier(initValue);
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
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
                    const Icon(FluentIcons.volume3),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: volumeNotifier,
                          builder: (context, volume, _) {
                            return Slider(
                              onChanged: (value) {
                                volumeNotifier.value = value;
                                onChanged(value);
                              },
                              value: volume,
                              max: 1,
                              vertical: true,
                            );
                          },
                        ),
                      ),
                    ),
                    const Icon(FluentIcons.volume_disabled),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget soundController({
    required double volume,
    required Function(double value) onChanged,
  }) {
    final volumeIcon = Icon(() {
      if (volume == 0) {
        return FluentIcons.volume_disabled;
      }
      if (volume < 0.3) {
        return FluentIcons.volume1;
      }
      if (volume < 0.6) {
        return FluentIcons.volume2;
      }
      return FluentIcons.volume3;
    }());
    return IconButton(
      onPressed: () {
        showSlider(
          context,
          initValue: volume,
          onChanged: onChanged,
        );
      },
      icon: volumeIcon,
    );
  }

  Widget progressBar({
    required Duration position,
    required Duration duration,
    required Function(Duration value) onChanged,
  }) {
    double percent = (position.inMilliseconds / duration.inMilliseconds);
    if (percent.isNaN) {
      percent = 0;
    }
    final ValueNotifier<double> valueNotifier = ValueNotifier(percent);

    return ValueListenableBuilder<double>(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return Slider(
          value: value,
          max: 1.0,
          onChanged: (value) {
            valueNotifier.value = value;
          },
          onChangeEnd: (value) {
            onChanged(
              Duration(milliseconds: (duration.inMilliseconds * value).toInt()),
            );
          },
        );
      },
    );
  }

  String convertDurationText(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget durationText({
    required Duration position,
    required Duration duration,
  }) {
    final current = convertDurationText(position);
    final total = convertDurationText(duration);
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: const TextStyle(
          // fontSize: state.isChangingDuration ? 15 : 14,
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
        child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          builder: (context, state) {
            final status = state.status;
            switch (status) {
              case AudioPlayerViewStatus.init:
              case AudioPlayerViewStatus.loading:
                return const BibleLoading();
              case AudioPlayerViewStatus.failure:
                return const Text("Fail Text");
              case AudioPlayerViewStatus.success:
            }
            final audioState = state.audioState;
            final position = audioState.position;
            final duration = audioState.duration;
            return Row(
              children: [
                stateIcon(
                  onTapPlay: () {
                    if (audioState.playing) {
                      bloc.add(AudioPlayerEventPaused());
                    } else {
                      bloc.add(AudioPlayerEventPlayed());
                    }
                  },
                  isPlaying: audioState.playing,
                  processingState: audioState.state,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: progressBar(
                          position: position,
                          duration: duration,
                          onChanged: (value) {
                            bloc.add(AudioPlayerEventSeekPosition(value));
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      durationText(
                        position: position,
                        duration: duration,
                      ),
                      soundController(
                        volume: audioState.volume,
                        onChanged: (volume) {
                          bloc.add(AudioPlayerEventChangedVolume(volume));
                        },
                      ),
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
