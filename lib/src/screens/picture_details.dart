import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../utils/colors.dart';

class PictureDetailsArguments {
  PictureDetailsArguments({this.imageUrls = const [], this.selectedIndex = 0});

  final List<String> imageUrls;
  final int selectedIndex;
}

class PictureDetails extends HookWidget {
  const PictureDetails(
      {super.key, this.imageUrls = const [], this.selectedIndex = 0});
  final List<String> imageUrls;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg.basic,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: PageController(
              initialPage: selectedIndex,
            ),
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            enableRotation: false,
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: AppColors.bg.basic,
            ),
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 1),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            height: 48,
            child: Row(
              children: [
                TextButton(
                  onPressed: () => context.canPop() ? context.pop() : null,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.text.basic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
