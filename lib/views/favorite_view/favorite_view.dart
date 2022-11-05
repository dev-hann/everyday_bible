import 'package:fluent_ui/fluent_ui.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      children: const [
        Text("FavoriteView"),
      ],
    );
  }
}
