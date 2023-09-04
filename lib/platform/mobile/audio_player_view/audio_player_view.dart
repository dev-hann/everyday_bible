import 'package:everydaybible/model/audio/audio_state.dart';
import 'package:everydaybible/platform/mobile/audio_player_view/bloc/audio_player_bloc.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
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
      icon: Icon(!isPlaying ? Icons.play_arrow : Icons.pause),
    );
  }

  Widget progressBar({
    required AudioState audioState,
    required Duration position,
    required Duration duration,
    required Function(Duration value) onChanged,
  }) {
    switch (audioState.state) {
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return const SizedBox();
      case ProcessingState.idle:
      case ProcessingState.ready:
      case ProcessingState.completed:
    }
    final ValueNotifier valueNotifier =
        ValueNotifier(position.inMilliseconds / duration.inMilliseconds);
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return Slider(
          value: value,
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
    return Text("$current / $total");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case AudioPlayerViewStatus.init:
            return const BibleLoading();
          case AudioPlayerViewStatus.loading:
          case AudioPlayerViewStatus.failure:
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
            const SizedBox(width: 4.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: progressBar(
                      audioState: audioState,
                      position: position,
                      duration: duration,
                      onChanged: (value) {
                        bloc.add(AudioPlayerEventSeekPosition(value));
                      },
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  durationText(
                    position: position,
                    duration: duration,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
