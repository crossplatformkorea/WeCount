import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/assets.dart';
import '../utils/colors.dart';

class ImageOnNetwork extends HookWidget {
  const ImageOnNetwork({
    super.key,
    required this.imageURL,
    this.borderRadius = 25,
    this.placeholder,
    this.height = 50,
    this.width = 50,
    this.border,
  });

  final String imageURL;
  final double width;
  final Widget? placeholder;
  final double height;
  final double borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    var placeholderWidget = placeholder ??
        ImagePlaceholder(
            borderRadius: borderRadius, width: width, height: height);

    return imageURL.isEmpty
        ? Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: placeholderWidget,
          )
        : CachedNetworkImage(
            placeholder: (context, url) => placeholderWidget,
            imageUrl: imageURL,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                border: border,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => placeholderWidget,
            width: width,
            height: height,
          );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder(
      {super.key, this.borderRadius = 25, this.width = 50, this.height = 50});
  final double borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.role.primary),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: AppColors.text.placeholder,
          child: Image(image: Assets.icCoin),
        ),
      ),
    );
  }
}
