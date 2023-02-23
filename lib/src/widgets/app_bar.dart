import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../services/fcm_service.dart';
import '../utils/assets.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import 'button.dart';
import 'user_card.dart';

class AppBarBack extends StatelessWidget with PreferredSizeWidget {
  const AppBarBack({
    Key? key,
    this.title,
    this.actions,
    this.iconColor,
    this.systemOverlayStyle,
    this.centerTitle = false,
    this.backgroundColor,
    this.onPressBack,
  }) : super(key: key);

  final Widget? title;
  final List<Widget>? actions;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color? iconColor;
  final bool? centerTitle;
  final Color? backgroundColor;
  final Function()? onPressBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      systemOverlayStyle: systemOverlayStyle ?? statusBarBrightness,
      leading: RawMaterialButton(
        padding: const EdgeInsets.all(0.0),
        shape: const CircleBorder(),
        onPressed: onPressBack ?? () => context.canPop() ? context.pop() : null,
        child: Icon(
          Icons.arrow_back,
          color: iconColor ?? AppColors.text.basic,
        ),
      ),
      elevation: 0.0,
      actions: actions,
      titleSpacing: 0.0,
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarHome extends HookWidget with PreferredSizeWidget {
  const AppBarHome({
    Key? key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.systemOverlayStyle,
    this.centerTitle,
    this.backgroundColor,

    /// Database user
    this.user,

    /// Firebase auth data
    this.currentUser,
    this.onPressSignIn,
  }) : super(key: key);

  final Widget? title;
  final bool automaticallyImplyLeading;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color? iconColor = null;
  final bool? centerTitle;
  final Color? backgroundColor;
  final UserModel? user;
  final User? currentUser;
  final VoidCallback? onPressSignIn;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppProvider>(context, listen: false);

    useEffect(() {
      if (currentUser != null && currentUser!.emailVerified) {
        FcmService.instance.requestFirebaseMessaging();
      }

      return null;
    }, [currentUser]);

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      systemOverlayStyle: systemOverlayStyle ?? statusBarBrightness,
      elevation: 0.0,
      leading: InkWell(
        onTap: () {
          if (context.canPop()) {
            while (context.canPop()) {
              context.pop();
            }

            return;
          }

          if (kIsWeb && GoRouter.of(context).location != '/intro') {
            context.go('/intro');
            return;
          }

          appState.showFeedsInIntro = !appState.showFeedsInIntro;
        },
        child: Ink(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image(image: Assets.icCoin, width: 32),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              user != null && currentUser != null && currentUser!.emailVerified
                  ? UserCard(user: user!)
                  : Button(
                      margin: const EdgeInsets.only(left: 4),
                      borderColor: AppColors.bg.border,
                      text: localization(context).signIn,
                      onPress: onPressSignIn,
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                    ),
            ],
          ),
        ),
      ],
      titleSpacing: 0.0,
      title: Padding(padding: const EdgeInsets.only(left: 20), child: title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
