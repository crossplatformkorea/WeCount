import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../routes.dart';
import '../models/community_model.dart';
import '../models/feed_model.dart';
import '../models/user_model.dart';
import '../repositories/feed_repository.dart';
import '../repositories/user_repository.dart';
import '../screens/reply.dart';
import '../services/dynamic_link_service.dart';
import '../utils/colors.dart';
import '../utils/exceptions.dart';
import '../utils/localization.dart';
import '../utils/snackbar.dart';
import '../utils/styles.dart';
import '../utils/tools.dart';
import 'images.dart';
import 'popup_menu.dart';
import 'reaction_controls.dart';

class FeedListItem extends HookWidget {
  const FeedListItem({
    super.key,
    required this.community,
    required this.feed,
    this.onPressUpdate,
    this.onTap,
    this.onReport,
    this.onBanUser,
    this.onTapPhoto,
    this.onTapCommunity,
    this.hideReply = false,
  });

  final CommunityModel? community;
  final FeedModel feed;

  /// Get updated feed
  final VoidCallback? onPressUpdate;
  final Function()? onTap;
  final Function? onReport;
  final Function? onBanUser;
  final Function(String photo, int index)? onTapPhoto;
  final Function()? onTapCommunity;
  final bool hideReply;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);

    var t = localization(context);
    var loading = useState(false);
    var formatCurrency = NumberFormat.simpleCurrency(
        locale: feed.currency.name == 'usd' ? 'en_US' : 'ko_KR');
    var amount = formatCurrency.format(feed.amount);
    var description = feed.description;
    var hashtags = [];

    // Hashtags
    var exp = RegExp(r'\B#\w\w+');
    exp.allMatches(feed.description).forEach((match) {
      var matchGroup = match.group(0);

      description = description.replaceAll(matchGroup!, '');
      hashtags.add(matchGroup);
    });

    var hasLikedState = useState(false);
    var hasDislikedState = useState(false);
    var likeCountState = useState(feed.likeCount);
    var dislikeCountState = useState(feed.dislikeCount);
    var replyCount = useState(feed.replyCount);

    useEffect(() {
      void setLikesAndDislikes() async {
        var disliked = await feed.hasDislikedItem();
        var liked = await feed.hasLikedItem();

        if (context.mounted) {
          hasDislikedState.value = disliked;
          hasLikedState.value = liked;
        }
      }

      setLikesAndDislikes();

      return null;
    }, []);

    Future<void> shareLink() async {
      if (kIsWeb) {
        var webUrl = 'https://wecount.space/feed?id=${feed.id}';

        unawaited(Share.share(webUrl));
        return;
      }

      var link = 'feed?id=${feed.id}';

      var shortLink = await DynamicLinkService.instance.create(
        link: link,
        short: true,
      );

      try {
        unawaited(Share.share(shortLink));
      } catch (err) {
        logger.e('share err: $err');
      }
    }

    Future<void> tapLike() async {
      if (loading.value) return;
      loading.value = true;

      try {
        if (hasDislikedState.value) {
          await FeedRepository.instance.dislike(feed.id, false);
          if (context.mounted) {
            hasDislikedState.value = false;
            dislikeCountState.value = dislikeCountState.value - 1;
          }
        }

        await FeedRepository.instance.like(feed.id, !hasLikedState.value);

        if (context.mounted) {
          hasLikedState.value = !hasLikedState.value;
          likeCountState.value =
              likeCountState.value + (hasLikedState.value ? 1 : -1);

          loading.value = false;
        }
      } on UserNotSignedInException {
        if (context.mounted) {
          snackbar.alert(context, t.exceptionNotSignedIn);
        }
      }
    }

    Future<void> tapDislike() async {
      if (loading.value) return;
      loading.value = true;

      try {
        if (hasLikedState.value) {
          await FeedRepository.instance.like(feed.id, false);

          if (context.mounted) {
            hasLikedState.value = false;
            likeCountState.value = likeCountState.value - 1;
          }
        }

        await FeedRepository.instance.dislike(feed.id, !hasDislikedState.value);

        if (context.mounted) {
          hasDislikedState.value = !hasDislikedState.value;
          dislikeCountState.value =
              dislikeCountState.value + (hasDislikedState.value ? 1 : -1);

          loading.value = false;
        }
      } on UserNotSignedInException {
        if (context.mounted) {
          snackbar.alert(context, t.exceptionNotSignedIn);
        }
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.bg.basic,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User row with amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FutureBuilder(
                      future:
                          UserRepository.instance.getFromRef(feed.writerRef),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var user = snapshot.data as UserModel;

                          return Row(
                            children: [
                              InkWell(
                                onTap: () => logger.d('User tapped'),
                                child: Ink(
                                  child: ImageOnNetwork(
                                    imageURL:
                                        user.thumbUrl ?? user.photoUrl ?? '',
                                    width: 40,
                                    height: 40,
                                    borderRadius: 20,
                                    border: Border.all(
                                      color: AppColors.role.primary,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: onTapCommunity,
                                              child: Text(
                                                community?.title ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Body3TextStyle().merge(
                                                  TextStyle(
                                                    color: AppColors
                                                        .text.secondary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              user.displayName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Body3TextStyle().merge(
                                                const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      }),
                ),
                feed.type == FeedType.none
                    ? const SizedBox()
                    : Text(
                        '${feed.type == FeedType.consume ? "-" : ""}$amount',
                        style: Body2TextStyle().merge(
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: feed.type == FeedType.income
                                ? AppColors.role.primary
                                : AppColors.role.danger,
                          ),
                        ),
                      ),
              ],
            ),

            // 2. Description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SelectableLinkify(
                onOpen: (link) => launchUrl(Uri.parse(link.url)),
                text: description,
                linkStyle: TextStyle(
                  color: AppColors.text.link,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                        children: hashtags
                            .map((e) => Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.text.link,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    e,
                                    style: Body3TextStyle().merge(TextStyle(
                                      color: AppColors.text.contrast,
                                    )),
                                  ),
                                ))
                            .toList()),
                  ),
                  feed.isWriter
                      ? TextButton(
                          onPressed: onPressUpdate,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.text.link,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  t.update,
                                  style: Body3TextStyle().merge(TextStyle(
                                    color: AppColors.text.link,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        )
                      : FirebaseAuth.instance.currentUser != null
                          ? buildPeerPopupMenu(
                              onReport: onReport,
                              onBanUser: onBanUser,
                              context: context,
                            )
                          : const SizedBox(),
                  TextButton(
                    onPressed: shareLink,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          color: AppColors.text.link,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            t.share,
                            style: Body3TextStyle().merge(TextStyle(
                              color: AppColors.text.link,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 3. Pictures
            feed.picture.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      height: 240,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: feed.picture
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () => onTapPhoto?.call(
                                      e, feed.picture.indexOf(e)),
                                  child: Ink(
                                      child: ImageOnNetwork(
                                    imageURL: e,
                                    width: 240,
                                    height: 240,
                                    borderRadius: 0,
                                    border: Border.all(
                                      color: AppColors.role.primary,
                                      width: 1,
                                    ),
                                  )),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      timeago.format(feed.createdAt),
                      style: Body3TextStyle().merge(
                        TextStyle(
                          color: AppColors.text.disabled,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),
              child: Divider(
                color: AppColors.bg.border,
                thickness: 0.3,
              ),
            ),
            ReactionControls(
              onTapLike: tapLike,
              onTapDislike: tapDislike,
              likeCount: likeCountState.value,
              dislikeCount: dislikeCountState.value,
              hasDisliked: hasDislikedState.value,
              hasLiked: hasLikedState.value,
              onTapReply: hideReply
                  ? null
                  : () => context.pushNamed(
                        AppRoutes.reply.name,
                        params: {'feedId': feed.id},
                        extra: ReplyArguments(
                          feed: feed,
                          onReplyAdded: (reply) =>
                              context.mounted ? replyCount.value += 1 : null,
                          onReplyDeleted: (reply) =>
                              context.mounted ? replyCount.value -= 1 : null,
                        ),
                      ),
              replyCount: replyCount.value,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
