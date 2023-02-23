import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CheckBox extends StatelessWidget {
  const CheckBox({
    super.key,
    this.fillColor,
    this.checkColor,
    this.checked = false,
    this.onChecked,
    this.borderRadius = 3,
    this.leftWidget,
    this.rightWidget,
  });

  final Color? fillColor;
  final Color? checkColor;
  final bool checked;
  final Function(bool?)? onChecked;
  final double borderRadius;
  final Widget? leftWidget;
  final Widget? rightWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leftWidget != null ? Expanded(child: leftWidget!) : const SizedBox(),
        Checkbox(
          fillColor:
              MaterialStateProperty.all(fillColor ?? AppColors.text.basic),
          value: checked,
          checkColor: AppColors.bg.basic,
          onChanged: onChecked,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        rightWidget != null ? Expanded(child: rightWidget!) : const SizedBox(),
      ],
    );
  }
}
