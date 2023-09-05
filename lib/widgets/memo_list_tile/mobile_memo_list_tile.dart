import 'package:everydaybible/model/memo/memo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MobileMemoListTile extends StatelessWidget {
  const MobileMemoListTile({
    super.key,
    required this.memo,
    required this.onTap,
    required this.onTapDelete,
  });

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
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
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
      ),
    );
  }
}
