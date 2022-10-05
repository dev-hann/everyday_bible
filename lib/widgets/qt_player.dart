import 'package:everydaybible/models/quite_time_format.dart';
import 'package:fluent_ui/fluent_ui.dart';

class QTPlayer extends StatelessWidget {
  QTPlayer({
    super.key,
    required this.isPlaying,
    required this.onTapPlay,
    required this.title,
    required this.currentDuration,
    required this.totalDuration,
    required this.onChangedDuration,
  }) : progressNotifier =
            ValueNotifier(currentDuration.inMilliseconds.toDouble());

  final bool isPlaying;
  final VoidCallback onTapPlay;
  final String title;
  final Duration currentDuration;
  final Duration totalDuration;
  final Function(double value) onChangedDuration;
  final ValueNotifier<bool> durationTextNotifier = ValueNotifier(false);
  final ValueNotifier<double> progressNotifier;

  Widget stateIcon() {
    return IconButton(
      onPressed: onTapPlay,
      icon: Icon(!isPlaying ? FluentIcons.play : FluentIcons.pause),
    );
  }

  Widget titleText() {
    return Text(title);
  }

  Widget progressBar({
    required double value,
    required double maxValue,
    required Function(double value) onChangeStart,
    required Function(double value) onChangeEnd,
    required Function(double value) onChange,
  }) {
    return Slider(
      value: value,
      max: maxValue,
      onChangeStart: onChangeStart,
      onChanged: onChange,
      onChangeEnd: onChangeEnd,
    );
  }

  Widget durationText({required double progressValue}) {
    final current =
        QuiteTimeFormat.duration(Duration(milliseconds: progressValue.toInt()));
    final total = QuiteTimeFormat.duration(totalDuration);
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        fontSize: durationTextNotifier.value ? 15 : 14,
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
        child: Row(
          children: [
            stateIcon(),
            const SizedBox(width: 16.0),
            titleText(),
            const SizedBox(width: 16.0),
            ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, value, _) {
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: progressBar(
                            value: value,
                            maxValue: totalDuration.inMilliseconds.toDouble(),
                            onChangeStart: (_) {
                              durationTextNotifier.value = true;
                            },
                            onChange: (value) {
                              progressNotifier.value = value;
                            },
                            onChangeEnd: (value) {
                              onChangedDuration(value);
                              durationTextNotifier.value = false;
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        durationText(progressValue: value),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
