import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/colors.dart';
import '../utils/general.dart';
import '../utils/validator.dart';

class PhotoCardItem extends StatelessWidget {
  const PhotoCardItem({
    super.key,
    required this.uri,
    this.onTap,
    this.onDelete,
    this.margin,
    this.padding,
    this.width = 72,
    this.height = 72,
  });

  final String uri;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.bg.border),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.bg.paper,
                image: Validator.instance.validateURL(uri)
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(uri),
                      )
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(uri)),
                      ),
              ),
            ),
            if (onDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.text.basic.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: AppColors.text.contrast,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PhotoCardAddItem extends StatelessWidget {
  const PhotoCardAddItem({
    super.key,
    this.margin,
    this.padding,
    this.width = 72,
    this.height = 72,
    this.onSelectImage,
  });

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double width;
  final double height;
  final Function(XFile file)? onSelectImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: GestureDetector(
        onTap: () async {
          var imageFile = await General.instance.chooseImage();

          if (imageFile != null) {
            onSelectImage?.call(imageFile);
          }
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.bg.border),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.bg.paper,
              ),
              child: Icon(Icons.add, color: AppColors.text.placeholder),
            ),
          ],
        ),
      ),
    );
  }
}
