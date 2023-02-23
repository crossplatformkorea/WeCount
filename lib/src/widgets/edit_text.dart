import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/styles.dart';

class EditText extends StatelessWidget {
  const EditText({
    Key? key,
    this.focusNode,
    this.margin,
    this.padding,
    this.label = '',
    this.fontSize = 16,
    this.textHint,
    this.iconColor,
    this.cursorColor,
    this.errorText = '',
    this.textEditingController,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.validator,
    this.keyboardType,
    this.isSecret = false,
    this.hasChecked = false,
    this.showBorder = true,
    this.borderRadius = 8,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputDecoration,
    this.labelStyle,
    this.textStyle,
    this.textHintStyle,
    this.errorTextStyle,
    this.onTap,
    this.prefixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
  }) : super(key: key);

  final FocusNode? focusNode;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String label;
  final double fontSize;
  final int minLines;
  final int maxLines;
  final InputDecoration? inputDecoration;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final String? textHint;
  final Color? iconColor;
  final Color? cursorColor;
  final String errorText;
  final TextStyle? textHintStyle;
  final TextStyle? errorTextStyle;
  final bool isSecret;
  final bool hasChecked;
  final double borderRadius;
  final bool showBorder;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Widget? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    var focusedOutlineBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1.3, color: AppColors.text.basic),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppColors.text.placeholder),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var disableBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppColors.bg.border),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var focusedErrorBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1.3, color: AppColors.role.danger),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var errorBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppColors.role.danger),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    label,
                    style: Body3TextStyle().merge(labelStyle),
                  ),
                )
              : const SizedBox(),
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              TextField(
                key: key,
                keyboardType: keyboardType,
                obscureText: isSecret,
                focusNode: focusNode,
                minLines: minLines,
                cursorColor: cursorColor ?? AppColors.text.placeholder,
                maxLines: maxLines,
                controller: textEditingController,

                onSubmitted: onSubmitted,
                enabled: enabled,
                readOnly: readOnly,

                /// Set default [InputDecoration] below instead of constructor
                /// because we need to apply optional parameters given in other props.
                ///
                /// You can pass [inputDecoration] to replace default [InputDecoration].
                decoration: inputDecoration ??
                    InputDecoration(
                      prefixIcon: prefixIcon,
                      prefixIconColor: iconColor ?? AppColors.text.placeholder,
                      iconColor: iconColor ?? AppColors.text.placeholder,
                      suffixIconColor: iconColor ?? AppColors.text.placeholder,
                      focusColor: AppColors.text.basic,
                      fillColor: !enabled
                          ? AppColors.text.disabled
                          : AppColors.text.primary,
                      filled: !enabled,
                      disabledBorder:
                          showBorder ? disableBorder : InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      focusedBorder:
                          showBorder ? focusedOutlineBorder : InputBorder.none,
                      enabledBorder:
                          showBorder ? outlineBorder : InputBorder.none,
                      errorBorder: showBorder ? errorBorder : InputBorder.none,
                      focusedErrorBorder:
                          showBorder ? focusedErrorBorder : InputBorder.none,
                      hintText: textHint,
                      hintStyle: TextStyle(
                        fontSize: fontSize,
                        color: AppColors.text.placeholder,
                      ).merge(textHintStyle),
                      errorText: errorText.isEmpty ? null : errorText,
                      errorStyle: TextStyle(
                        fontSize: fontSize,
                        color: AppColors.role.danger,
                      ).merge(errorTextStyle),
                      errorMaxLines: 10,
                    ),
                autofocus: autofocus,
                style: TextStyle(
                  fontSize: fontSize,
                  color: AppColors.text.primary,
                ).merge(textStyle),
                onChanged: onChanged,
                onEditingComplete: onEditingComplete,
                textInputAction: textInputAction,
                onTap: onTap,
                autocorrect: false,
              ),
              hasChecked
                  ? const Positioned(
                      right: 8.0,
                      top: 12.0,
                      child: Icon(
                        Icons.check,
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}

class EditFormText extends StatelessWidget {
  const EditFormText({
    Key? key,
    this.focusNode,
    this.margin,
    this.padding,
    this.fontSize = 16,
    this.label = '',
    this.textHint,
    this.iconColor,
    this.cursorColor,
    this.errorText = '',
    this.textEditingController,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.validator,
    this.keyboardType,
    this.isSecret = false,
    this.hasChecked = false,
    this.autofocus = false,
    this.showBorder = true,
    this.borderRadius = 8,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputDecoration,
    this.labelStyle,
    this.textStyle,
    this.textHintStyle,
    this.errorStyle,
    this.onTap,
    this.prefixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
  }) : super(key: key);

  final FocusNode? focusNode;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String label;
  final double fontSize;
  final int minLines;
  final int maxLines;
  final InputDecoration? inputDecoration;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final String? textHint;
  final Color? iconColor;
  final Color? cursorColor;
  final TextStyle? textHintStyle;
  final String errorText;
  final TextStyle? errorStyle;
  final bool isSecret;
  final bool hasChecked;
  final bool autofocus;
  final bool showBorder;
  final double borderRadius;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Widget? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    var focusedOutlineBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1.5, color: AppColors.text.basic),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppColors.text.placeholder),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var focusedErrorBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1.5, color: AppColors.role.danger),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    var errorBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppColors.role.danger),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );

    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    label,
                    style: Body3TextStyle().merge(labelStyle),
                  ),
                )
              : const SizedBox(),
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              TextFormField(
                key: key,
                validator: validator,
                keyboardType: keyboardType,
                obscureText: isSecret,
                focusNode: focusNode,
                initialValue: initialValue,
                minLines: minLines,
                cursorColor: cursorColor ?? AppColors.text.placeholder,
                maxLines: maxLines,
                controller: textEditingController,
                enabled: enabled,
                readOnly: readOnly,

                /// Set default [InputDecoration] below instead of constructor
                /// because we need to apply optional parameters given in other props.
                ///
                /// You can pass [inputDecoration] to replace default [InputDecoration].
                decoration: inputDecoration ??
                    InputDecoration(
                      prefixIcon: prefixIcon,
                      prefixIconColor: iconColor ?? AppColors.text.placeholder,
                      iconColor: iconColor ?? AppColors.text.placeholder,
                      suffixIconColor: iconColor ?? AppColors.text.placeholder,
                      focusColor: AppColors.text.basic,
                      fillColor:
                          !enabled ? AppColors.bg.paper : AppColors.bg.basic,
                      filled: !enabled,
                      // contentPadding: const EdgeInsets.all(16),
                      focusedBorder:
                          showBorder ? focusedOutlineBorder : InputBorder.none,
                      enabledBorder:
                          showBorder ? outlineBorder : InputBorder.none,
                      errorBorder: showBorder ? errorBorder : InputBorder.none,
                      focusedErrorBorder:
                          showBorder ? focusedErrorBorder : InputBorder.none,
                      hintText: textHint,
                      hintStyle: TextStyle(
                        fontSize: fontSize,
                        color: AppColors.text.placeholder,
                      ).merge(textHintStyle),
                      errorText: errorText.isEmpty ? null : errorText,
                      errorStyle: TextStyle(
                        fontSize: fontSize,
                        color: AppColors.role.danger,
                      ).merge(errorStyle),
                      errorMaxLines: 10,
                    ),
                autofocus: autofocus,
                style: TextStyle(
                  fontSize: fontSize,
                  color: AppColors.text.primary,
                ).merge(textStyle),
                onChanged: onChanged,
                onFieldSubmitted: onSubmitted,
                onEditingComplete: onEditingComplete,
                textInputAction: textInputAction,
                onTap: onTap,
                autocorrect: false,
              ),
              hasChecked
                  ? const Positioned(
                      right: 8.0,
                      top: 12.0,
                      child: Icon(
                        Icons.check,
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
