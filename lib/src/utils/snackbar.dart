import 'package:flutter/material.dart';

import 'colors.dart';

class _Snackbar {
  factory _Snackbar() {
    return _singleton;
  }

  _Snackbar._internal();
  static final _Snackbar _singleton = _Snackbar._internal();

  void alert(
    BuildContext context,
    String message, {
    String? title,
    TextStyle? textStyle,
    Color? textColor,
    Color? backgroundColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
    EdgeInsets margin = const EdgeInsets.only(bottom: 28, left: 28, right: 28),
  }) {
    var snackBar = SnackBar(
      dismissDirection: DismissDirection.down,
      margin: margin,
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? AppColors.text.basic)
                    .merge(textStyle),
              ),
            ),
            ClipOval(
              child: Material(
                child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        size: 14,
                        Icons.close_sharp,
                      ),
                    ),
                    onTap: () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

var snackbar = _Snackbar();
