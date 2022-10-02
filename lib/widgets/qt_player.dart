import 'package:fluent_ui/fluent_ui.dart';

class QTPlayer extends StatelessWidget {
  const QTPlayer({
    super.key,
    required this.isPlaying,
    required this.title,
    required this.currentDuration,
    required this.totalDuration,
  });
  final bool isPlaying;
  final String title;
  final Duration currentDuration;
  final Duration totalDuration;

  Widget stateIcon() {
    return IconButton(
      onPressed: () {},
      icon: Icon(!isPlaying ? FluentIcons.play : FluentIcons.pause),
    );
  }

  Widget titleText() {
    return Text(title);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            stateIcon(),
            titleText(),
          ],
        ),
      ),
    );
  }
}
