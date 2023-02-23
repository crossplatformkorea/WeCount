import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/localization.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
    this.size,
    this.strokeWidth = 2,
  }) : super(key: key);

  final double? size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    var t = localization(context);

    return Scaffold(
      backgroundColor: AppColors.bg.basic,
      body: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            semanticsLabel: t.loading,
            backgroundColor: AppColors.role.brand,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.bg.basic),
          ),
        ),
      ),
    );
  }
}
