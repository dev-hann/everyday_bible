import 'package:everydaybible/model/memo/memo.dart';
import 'package:flutter/material.dart';

class MobileMemoListTile extends StatelessWidget {
  const MobileMemoListTile({
    super.key,
    required this.memo,
    required this.onTap,
  });

  final Memo memo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
