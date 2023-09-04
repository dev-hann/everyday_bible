import 'package:everydaybible/model/memo/memo.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DesktopMemoListTile extends StatelessWidget {
  const DesktopMemoListTile({
    super.key,
    required this.isSelected,
    required this.memo,
    required this.onTap,
  });
  final bool isSelected;
  final Memo memo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      selected: isSelected,
      onPressed: onTap,
      title: Text(
        memo.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        memo.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
