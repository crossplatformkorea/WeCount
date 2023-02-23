import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../routes.dart';
import '../utils/assets.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import 'app_bar.dart';

class NotFound extends HookWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    return Scaffold(
      backgroundColor: AppColors.bg.basic,
      appBar: AppBarBack(
        onPressBack: () => context.goNamed(AppRoutes.intro.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Center(
            child: Column(
              children: [
                Image(
                    image: Assets.icCoin,
                    color: AppColors.text.placeholder.withOpacity(0.3)),
                const SizedBox(height: 20),
                Text(
                  t.notFound,
                  style: TextStyle(
                    color: AppColors.text.placeholder,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
