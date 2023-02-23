import 'package:flutter/material.dart';
import '../utils/colors.dart';

enum ButtonType {
  solid,
  outline,
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.buttonType = ButtonType.solid,
    this.text = '',
    this.width,

    /// Adhoc used for button with default width but with specific height
    this.height = 52,
    this.onPress,
    this.color,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.showContainerBackground = false,
    this.margin = const EdgeInsets.only(left: 0, right: 0),
    this.padding,
    this.borderRadius = 8.0,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.loading = false,
    this.disabled = false,
    this.autofocus = false,
    this.leftWidget,
    this.rightWidget,
    this.textStyle,
    this.minimumSize,
    this.maximumSize,
    this.borderShape,
  }) : super(key: key);

  final ButtonType buttonType;
  final String? text;
  final double? width;
  final double height;
  final VoidCallback? onPress;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final bool showContainerBackground;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final bool loading;
  final bool disabled;
  final bool autofocus;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final TextStyle? textStyle;
  final Size? minimumSize;
  final Size? maximumSize;
  final MaterialStateProperty<OutlinedBorder?>? borderShape;

  Widget _renderLoading(BuildContext context) {
    return CircularProgressIndicator(
      semanticsLabel: 'loading',
      backgroundColor: backgroundColor,
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(
          textStyle?.color ?? AppColors.text.basic),
    );
  }

  Widget _renderContent(BuildContext context) {
    var textColor = buttonType == ButtonType.solid
        ? AppColors.text.contrast
        : AppColors.text.basic;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          left: 0,
          child: leftWidget ?? const SizedBox(),
        ),
        SizedBox(
          child: Center(
            child: loading
                ? _renderLoading(context)
                : Text(
                    text!,
                    style: TextStyle(
                            color: color ?? textColor,
                            fontSize: fontSize,
                            fontWeight: fontWeight)
                        .merge(textStyle),
                  ),
          ),
        ),
        Positioned(
          right: 0,
          child: rightWidget ?? const SizedBox(),
        ),
      ],
    );
  }

  Widget _renderSolidButton(BuildContext context) {
    return ElevatedButton(
      onPressed: loading
          ? () {}
          : !disabled
              ? onPress
              : null,
      autofocus: autofocus,
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        backgroundColor: backgroundColor ?? AppColors.role.primary,
        padding: padding,
        fixedSize: Size(width ?? double.infinity, height),
        textStyle: TextStyle(
          color: color ?? AppColors.text.basic,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ).merge(textStyle),
        disabledForegroundColor: AppColors.text.contrast,
        disabledBackgroundColor:
            disabledBackgroundColor ?? AppColors.bg.disabled,
        elevation: 0,
      ).merge(ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
        shape: borderShape ??
            (borderWidth != 0.0
                ? MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      side: BorderSide(
                        color: borderColor,
                        width: borderWidth,
                      ),
                    ),
                  )
                : MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  )),
      )),
      child: _renderContent(context),
    );
  }

  Widget _renderOutlineButton(BuildContext context) {
    return OutlinedButton(
      autofocus: autofocus,
      clipBehavior: Clip.none,
      onPressed: loading
          ? () {}
          : !disabled
              ? onPress
              : null,
      style: OutlinedButton.styleFrom(
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        side: BorderSide(color: color ?? AppColors.text.basic, width: 1),
        padding: padding,
        fixedSize: Size(width ?? double.infinity, height),
        textStyle: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ).merge(textStyle),
        disabledForegroundColor: AppColors.text.contrast,
        disabledBackgroundColor: AppColors.bg.disabled,
        elevation: 0,
      ).merge(ButtonStyle(
        shape: borderShape ??
            (borderWidth != 0.0
                ? MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      side: BorderSide(
                        color: borderColor,
                        width: borderWidth,
                      ),
                    ),
                  )
                : MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  )),
      )),
      child: _renderContent(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        width: width,
        height: height,
        child: buttonType == ButtonType.solid
            ? _renderSolidButton(context)
            : _renderOutlineButton(context));
  }
}
