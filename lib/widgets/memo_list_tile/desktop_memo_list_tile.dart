import 'package:everydaybible/model/memo/memo.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DesktopMemoListTile extends StatelessWidget {
  const DesktopMemoListTile({
    super.key,
    required this.isSelected,
    required this.memo,
    required this.onTap,
    required this.onTapDelete,
  });
  final bool isSelected;
  final Memo memo;
  final VoidCallback onTap;
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        dragDismissible: true,
        dismissible: DismissiblePane(
          onDismissed: onTapDelete,
        ),
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            autoClose: false,
            onPressed: (context) {
              final controller = Slidable.of(context);
              controller?.dismiss(
                ResizeRequest(
                  const Duration(milliseconds: 300),
                  onTapDelete,
                ),
                duration: const Duration(milliseconds: 300),
              );
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: FluentIcons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        tileColor: ButtonState.all(Colors.grey),
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
        trailing: const Icon(FluentIcons.link),
      ),
    );
  }
}
