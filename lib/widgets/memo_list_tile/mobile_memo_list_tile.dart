import 'dart:async';

import 'package:everydaybible/model/memo/memo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:forui/forui.dart';

/// List tile showing a memo, swipeable to delete.
class MobileMemoListTile extends StatelessWidget {
  /// Creates a memo list tile.
  const MobileMemoListTile({
    required this.memo,
    required this.onTap,
    required this.onTapDelete,
    super.key,
  });

  /// Memo displayed by this tile.
  final Memo memo;

  /// Called when the tile body is tapped.
  final VoidCallback onTap;

  /// Called when the memo is deleted via swipe or delete action.
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        dismissible: DismissiblePane(
          onDismissed: onTapDelete,
        ),
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            autoClose: false,
            onPressed: (context) {
              final controller = Slidable.of(context);
              // Fire-and-forget: only the dismiss animation runs here.
              unawaited(
                controller?.dismiss(
                  ResizeRequest(
                    const Duration(milliseconds: 300),
                    onTapDelete,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            backgroundColor: colors.destructive,
            foregroundColor: colors.destructiveForeground,
            icon: FLucideIcons.trash2,
            label: 'Delete',
          ),
        ],
      ),
      child: FTile(
        onPress: onTap,
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
