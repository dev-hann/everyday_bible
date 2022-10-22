import 'package:fluent_ui/fluent_ui.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      children: const [
        Text("SettingView"),
      ],
    );
  }
}
