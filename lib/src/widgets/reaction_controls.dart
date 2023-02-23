import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';

class LikeDislikeControls extends HookWidget {
  const LikeDislikeControls({
    super.key,
    this.padding = EdgeInsets.zero,
    this.onTapLike,
    this.onTapDislike,
    this.hasLiked = false,
    this.hasDisliked = false,
    this.likeCount = 0,
    this.dislikeCount = 0,
  });
  final EdgeInsets padding;
  final GestureTapCallback? onTapLike;
  final GestureTapCallback? onTapDislike;
  final bool hasLiked;
  final bool hasDisliked;
  final int likeCount;
  final int dislikeCount;

  @override
  Widget build(BuildContext context) {
    var t = localization(context);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Like
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: onTapLike,

              /// Apply [InkWell] border radius
              ///
              /// https://stackoverflow.com/a/64410674/8841562
              customBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: AppColors.bg.border,
                    width: 1,
                  )),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(children: [
                        Icon(
                          hasLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 20,
                          color: AppColors.text.basic,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          t.like,
                          style: TextStyle(
                            color: AppColors.text.placeholder,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                    ),
                    Text(
                      '$likeCount',
                      style: TextStyle(
                        color: AppColors.text.placeholder,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Dislike,
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: onTapDislike,

              /// Apply [InkWell] border radius
              ///
              /// https://stackoverflow.com/a/64410674/8841562
              customBorder: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(8)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.bg.border),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          hasDisliked
                              ? const Icon(Icons.thumb_down, size: 20)
                              : const Icon(Icons.thumb_down_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            t.dislike,
                            style: TextStyle(
                                color: AppColors.text.placeholder,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$dislikeCount',
                      style: TextStyle(
                          color: AppColors.text.placeholder,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Controls with reply button including like and dislike
class ReactionControls extends LikeDislikeControls {
  const ReactionControls({
    super.key,
    super.onTapLike,
    super.onTapDislike,
    super.likeCount,
    super.dislikeCount,
    super.hasDisliked,
    super.hasLiked,
    super.padding,
    this.replyCount = 0,
    this.onTapReply,
  });

  final int replyCount;
  final GestureTapCallback? onTapReply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onTapReply != null
              ? Material(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: AppColors.bg.basic,
                  child: InkWell(
                    onTap: onTapReply,
                    customBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: AppColors.bg.border,
                          width: 1,
                        )),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 20,
                            color: AppColors.text.basic,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$replyCount',
                            style: TextStyle(
                                color: AppColors.text.basic,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Like
              Material(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
                color: AppColors.bg.basic,
                child: InkWell(
                  onTap: onTapLike,

                  /// Apply [InkWell] border radius
                  ///
                  /// https://stackoverflow.com/a/64410674/8841562
                  customBorder: RoundedRectangleBorder(
                    side: BorderSide(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: AppColors.bg.border,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: AppColors.bg.border,
                        width: 1,
                      )),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(8),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          color: AppColors.text.basic,
                          hasLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 32),
                        Text(
                          '$likeCount',
                          style: TextStyle(
                              color: AppColors.text.basic,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Dislike,
              Material(
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
                color: AppColors.bg.basic,
                child: InkWell(
                  onTap: onTapDislike,

                  /// Apply [InkWell] border radius
                  ///
                  /// https://stackoverflow.com/a/64410674/8841562
                  customBorder: RoundedRectangleBorder(
                    side: BorderSide(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: AppColors.bg.border,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.bg.border),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        hasDisliked
                            ? Icon(Icons.thumb_down,
                                size: 20, color: AppColors.text.basic)
                            : Icon(Icons.thumb_down_outlined,
                                size: 20, color: AppColors.text.basic),
                        const SizedBox(width: 32),
                        Text(
                          '$dislikeCount',
                          style: TextStyle(
                              color: AppColors.text.basic,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
