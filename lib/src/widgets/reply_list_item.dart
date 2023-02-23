import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../models/reply_model.dart';
import '../providers/app_provider.dart';
import '../repositories/reply_repository.dart';
import '../utils/colors.dart';
import '../utils/general.dart';
import '../utils/utils.dart';
import 'reaction_controls.dart';
import 'user_list_item.dart';

class ReplyListItem extends HookWidget {
  const ReplyListItem({
    super.key,
    required this.reply,
    this.onDelete,
    this.onReport,
    this.onBanUser,
    this.onTapReply,
    this.onTapLike,
    this.onTapDisLike,
    this.hasLiked = false,
    this.hasDisliked = false,
  });

  final ReplyModel reply;
  final Function? onDelete;
  final Function? onReport;
  final BanUserCallback? onBanUser;
  final Function()? onTapReply;
  final Function()? onTapLike;
  final Function()? onTapDisLike;
  final bool hasLiked;
  final bool hasDisliked;

  @override
  Widget build(BuildContext context) {
    Widget buildReplyItem() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserListItemContainer(
            userRef: reply.writerRef,
            padding: const EdgeInsets.symmetric(vertical: 12),
            isUserItem: reply.isWriter,
            onDelete: onDelete,
            onBanUser: onBanUser,
            onReport: onReport,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              reply.reply,
              style: TextStyle(fontSize: 16, color: AppColors.text.basic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              dateTimeFormat.format(reply.createdAt),
              style: TextStyle(fontSize: 12, color: AppColors.text.placeholder),
            ),
          ),
          ReactionControls(
            onTapReply: onTapReply,
            onTapLike: onTapLike,
            onTapDislike: onTapDisLike,
            likeCount: reply.likeCount,
            replyCount: reply.replyCount,
            dislikeCount: reply.dislikeCount,
            hasDisliked: hasDisliked,
            hasLiked: hasLiked,
          ),
        ],
      );
    }

    /// Build reply to reply widget
    if (reply.replyRef != null) {
      return SizedBox(
        // width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 38, left: 24),
              child: Transform.rotate(
                angle: 180 * pi / 180,
                child: Icon(Icons.reply, color: AppColors.text.basic),
              ),
            ),
            Expanded(child: buildReplyItem()),
          ],
        ),
      );
    }

    return buildReplyItem();
  }
}

class ReplyListItemContainer extends HookWidget {
  const ReplyListItemContainer({
    super.key,
    required this.reply,
    this.onDelete,
    this.onTapReply,
  });
  final ReplyModel reply;
  final Function()? onDelete;
  final Function(ReplyModel reply)? onTapReply;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    var loading = useState(false);
    var hasLikedState = useState(false);
    var hasDislikedState = useState(false);
    var replyState = useState(reply);

    useEffect(() {
      void setLikesAndDislikes() async {
        loading.value = true;
        var hasDisliked = await reply.hasDislikedItem();
        var hasLiked = await reply.hasLikedItem();

        if (context.mounted) {
          hasDislikedState.value = hasDisliked;
          hasLikedState.value = hasLiked;

          replyState.value = replyState.value.copyWith(
              likeCount: reply.likeCount,
              dislikeCount: reply.dislikeCount,
              replyCount: reply.replyCount);

          loading.value = false;
        }
      }

      setLikesAndDislikes();

      return null;
    }, [reply.likeCount, reply.dislikeCount, reply.replyCount]);

    Future<void> toggleLike() async {
      if (loading.value) return;
      loading.value = true;

      if (hasDislikedState.value) {
        await ReplyRepository.instance.dislike(reply.id, false);

        if (context.mounted) {
          hasDislikedState.value = false;

          replyState.value = replyState.value.copyWith(
            dislikeCount: replyState.value.dislikeCount - 1,
          );
        }
      }

      await ReplyRepository.instance.like(reply.id, !hasLikedState.value);

      if (context.mounted) {
        hasLikedState.value = !hasLikedState.value;

        replyState.value = replyState.value.copyWith(
          likeCount:
              replyState.value.likeCount + (hasLikedState.value ? 1 : -1),
        );

        loading.value = false;
      }
    }

    Future<void> toggleDislike() async {
      if (loading.value) return;
      loading.value = true;

      if (hasLikedState.value) {
        await ReplyRepository.instance.like(reply.id, false);
        hasLikedState.value = false;

        replyState.value = replyState.value.copyWith(
          likeCount: replyState.value.likeCount - 1,
        );
      }

      await ReplyRepository.instance.dislike(reply.id, !hasDislikedState.value);

      if (context.mounted) {
        hasDislikedState.value = !hasDislikedState.value;

        replyState.value = replyState.value.copyWith(
          dislikeCount:
              replyState.value.dislikeCount + (hasDislikedState.value ? 1 : -1),
        );

        loading.value = false;
      }
    }

    return Consumer<AppProvider>(builder: (context, state, child) {
      var bannedUserIds = state.bannedUserIds;

      /// Do not show banned user's content
      if (bannedUserIds.contains(reply.writerRef.id)) {
        return const SizedBox();
      }

      return ReplyListItem(
        reply: replyState.value,
        onBanUser: (userId) =>
            General.instance.banUser(context: context, userId: userId),
        onReport: () => General.instance.reportContent(context: context),
        onDelete: onDelete,
        onTapReply: onTapReply != null
            ? () => !loading.value ? onTapReply?.call(replyState.value) : {}
            : null,
        onTapLike: toggleLike,
        onTapDisLike: toggleDislike,
        hasDisliked: hasDislikedState.value,
        hasLiked: hasLikedState.value,
      );
    });
  }
}
