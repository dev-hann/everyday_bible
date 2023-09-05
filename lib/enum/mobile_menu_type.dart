import 'package:flutter/material.dart';

enum MobileMenuType {
  bible,
  quiteTime,
  memo,
  setting,
}

extension MobileMenuTypeExtension on MobileMenuType {
  String toTitle() {
    switch (this) {
      case MobileMenuType.bible:
        return "Bible";
      case MobileMenuType.quiteTime:
        return "Quite Time";
      case MobileMenuType.setting:
        return "Setting";
      case MobileMenuType.memo:
        return "Memo";
    }
  }

  IconData toIcons() {
    switch (this) {
      case MobileMenuType.bible:
        return Icons.book;
      case MobileMenuType.quiteTime:
        return Icons.bookmark;
      case MobileMenuType.setting:
        return Icons.settings;
      case MobileMenuType.memo:
        return Icons.note;
    }
  }
}
