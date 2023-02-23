import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/button.dart';
import '../assets.dart';
import '../colors.dart';
import '../localization.dart';
import '../styles.dart';
import 'find_pw_content.dart';
import 'sign_in_content.dart';
import 'sign_up_content.dart';

class _AlertDialog {
  _AlertDialog._internal();

  factory _AlertDialog() {
    return _singleton;
  }
  static final _AlertDialog _singleton = _AlertDialog._internal();

  void confirm(
    BuildContext context, {
    bool barrierDismissible = true,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    Color? confirmButtonBackgroundColor,
    Color? confirmTextColor,
    Function? onPress,
    Function? onPressCancel,

    /// By showing cancel button, user can cancel the action.
    /// Without cancel button, user can only confirm the action.
    bool showCancelButton = false,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(24),
          backgroundColor: AppColors.bg.basic,
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          actionsPadding: const EdgeInsets.all(24),
          title: Text(title, style: Heading5TextStyle()),
          content: Text(content, style: Body2TextStyle()),
          actions: <Widget>[
            Button(
                width: MediaQuery.of(context).size.width,
                text: confirmText ?? localization(context).yes,
                onPress: () {
                  Navigator.of(context).pop();
                  if (onPress != null) onPress();
                },
                color: confirmTextColor ?? AppColors.button.primary.text,
                backgroundColor: confirmButtonBackgroundColor ??
                    AppColors.button.primary.bg),
            showCancelButton
                ? Button(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    text: cancelText ?? localization(context).no,
                    onPress: () => onPressCancel ?? Navigator.of(context).pop(),
                    borderWidth: 0.5,
                    buttonType: ButtonType.outline,
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }

  void signIn(
    BuildContext context, {
    bool barrierDismissible = true,
  }) {
    var t = localization(context);
    var isMobile = MediaQuery.of(context).size.width <= 480;

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bg.basic,
          insetPadding: !isMobile ? EdgeInsets.zero : const EdgeInsets.all(24),
          titlePadding: const EdgeInsets.all(24),
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          actionsPadding: const EdgeInsets.all(24),
          title: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Image(image: Assets.icCoin),
                  ),
                  Text(t.signIn, style: Heading5TextStyle()),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: TextButton(
                  onPressed: () => context.canPop() ? context.pop() : null,
                  child: Icon(
                    Icons.close,
                    color: AppColors.text.basic,
                  ),
                ),
              ),
            ],
          ),
          content: const SignInContent(),
        );
      },
    );
  }

  void signUp(
    BuildContext context, {
    bool barrierDismissible = true,
  }) {
    var t = localization(context);
    var isMobile = MediaQuery.of(context).size.width <= 480;

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AlertDialog(
          insetPadding: !isMobile ? EdgeInsets.zero : const EdgeInsets.all(24),
          backgroundColor: AppColors.bg.basic,
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.canPop() ? context.pop() : null,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.text.basic,
                  ),
                ),
                Text(t.signUp, style: Heading5TextStyle()),
                TextButton(
                  onPressed: () => context.canPop() ? context.pop() : null,
                  child: Icon(
                    Icons.close,
                    color: AppColors.text.basic,
                  ),
                ),
              ],
            ),
          ),
          content: const SignUpContent(),
        );
      },
    );
  }

  void findPw(
    BuildContext context, {
    bool barrierDismissible = true,
  }) {
    var t = localization(context);
    var isMobile = MediaQuery.of(context).size.width <= 480;

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bg.basic,
          insetPadding: !isMobile ? EdgeInsets.zero : const EdgeInsets.all(24),
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.canPop() ? context.pop() : null,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.text.basic,
                  ),
                ),
                Text(t.findPw, style: Heading5TextStyle()),
                TextButton(
                  onPressed: () => context.canPop() ? context.pop() : null,
                  child: Icon(
                    Icons.close,
                    color: AppColors.text.basic,
                  ),
                ),
              ],
            ),
          ),
          content: const FindPwContent(),
        );
      },
    );
  }
}

var alertDialog = _AlertDialog();
