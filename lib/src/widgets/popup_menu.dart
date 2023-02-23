import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/localization.dart';

Widget buildPeerPopupMenu({
  required BuildContext context,
  required Function? onReport,
  required Function? onBanUser,
}) {
  var t = localization(context);

  return PopupMenuButton(
    iconSize: 20,
    color: AppColors.bg.paper,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Icon(Icons.more_vert, size: 18.0, color: AppColors.text.basic),
    ),
    itemBuilder: (context) {
      var popupMenuTextStyle = TextStyle(
        color: AppColors.text.basic,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );

      var items = <PopupMenuItem<int>>[];

      if (onReport != null) {
        items.add(
          PopupMenuItem<int>(
            textStyle: popupMenuTextStyle,
            value: 0,
            child: Text(t.report),
          ),
        );
      }

      if (onBanUser != null) {
        items.add(
          PopupMenuItem<int>(
            textStyle: popupMenuTextStyle,
            value: 1,
            child: Text(t.banUser),
          ),
        );
      }

      return items;
    },
    onSelected: (value) {
      if (value == 0 && onReport != null) {
        onReport();
        return;
      }

      if (value == 1 && onBanUser != null) {
        onBanUser();
        return;
      }
    },
  );
}
