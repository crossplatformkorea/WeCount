import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../utils/colors.dart';

class RadioGroup<T> extends HookWidget {
  const RadioGroup({
    super.key,
    this.label,
    this.padding,
    this.selected,
    this.onChanged,
    required this.values,
    this.names,
    this.strokeColor,
    this.borderRadius = 8,
    this.disabledStrokeColor,
    this.strokeWidth = 1,
    this.extraWidgetOnSelected,
  }) : assert(names == null || names.length == values.length,
            'The length of `names` should match with `values` when provided.');
  final EdgeInsets? padding;
  final T? selected;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final List<T> values;
  final List<String>? names;
  final double borderRadius;
  final Color? strokeColor;
  final Color? disabledStrokeColor;
  final double strokeWidth;
  final Widget? extraWidgetOnSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: AppColors.text.basic,
                    ),
                  ),
                )
              : const SizedBox(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: values.asMap().entries.map((entry) {
              var idx = entry.key;
              var e = entry.value;

              return Flexible(
                flex: 1,
                child: InkWell(
                  onTap: onChanged != null ? () => onChanged!.call(e) : null,

                  /// Apply [InkWell] border radius
                  ///
                  /// https://stackoverflow.com/a/64410674/8841562
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        left: idx == 0
                            ? Radius.circular(borderRadius)
                            : Radius.zero,
                        right: idx == values.length - 1
                            ? Radius.circular(borderRadius)
                            : Radius.zero),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: onChanged != null
                                ? strokeColor ?? AppColors.bg.border
                                : disabledStrokeColor ?? AppColors.bg.disabled,
                            width: strokeWidth,
                          ),
                        ),
                        borderRadius: idx == 0
                            ? BorderRadius.only(
                                topLeft: Radius.circular(borderRadius),
                                bottomLeft: Radius.circular(borderRadius),
                              )
                            : idx == values.length - 1
                                ? BorderRadius.only(
                                    topRight: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
                                  )
                                : null),
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Radio(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -2),
                                activeColor: AppColors.role.brand,
                                fillColor: MaterialStateProperty.all(
                                  AppColors.text.primary,
                                ),
                                value: e,
                                groupValue: selected,
                                onChanged: onChanged,
                              ),
                              names != null
                                  ? Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              names![idx].toString(),
                                              style: TextStyle(
                                                color: AppColors.text.basic,
                                                fontSize: 12,
                                              ),
                                            ),
                                            e == selected
                                                ? extraWidgetOnSelected ??
                                                    const SizedBox()
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
