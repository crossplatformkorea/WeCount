import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../routes.dart';
import '../models/community_model.dart';
import '../models/feed_model.dart';
import '../models/reply_model.dart';
import '../repositories/community_repository.dart';
import '../repositories/feed_repository.dart';
import '../repositories/reply_repository.dart';
import '../utils/alert_dialog/alert_dialog.dart';
import '../utils/colors.dart';
import '../utils/exceptions.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';
import '../utils/localization.dart';
import '../utils/snackbar.dart';
import '../utils/styles.dart';
import '../utils/tools.dart';
import '../utils/utils.dart';
import '../widgets/app_bar.dart';
import '../widgets/edit_text.dart';
import '../widgets/feed_list_item.dart';
import '../widgets/reply_list_item.dart';
import 'feed_edit.dart';
import 'picture_details.dart';
import 'reply.dart';

class Feed extends HookWidget {
  const Feed({
    super.key,
    required this.id,
    this.extra,
  });

  final String id;
  final ReplyArguments? extra;

  @override
  Widget build(BuildContext context) {
    var feed = useState<FeedModel?>(null);
    var loading = useState(false);

    useEffect(() {
      Future<void> fetchData() async {
        loading.value = true;
        var feedResult = await FeedRepository.instance.getWithId(id);

        if (context.mounted) {
          feed.value = feedResult;
          loading.value = false;
        }
      }

      fetchData();
      return null;
    }, []);

    var t = localization(context);
    var replyController = useTextEditingController();
    var replies = useState<List<ReplyModel>>([]);
    var replyText = useState('');
    var lastListId = useState<dynamic>(null);
    var community = useState<CommunityModel?>(null);

    Future<void> fetchNext(startAfter) async {
      assert(feed.value != null, 'feed should not be null');

      if (lastListId.value == startAfter) return;

      lastListId.value = startAfter;
      loading.value = true;

      var nextReplies = await ReplyRepository.instance.getMany(
        type: ReplyType.feed,
        ref: feed.value!.ref,
        startAfter: startAfter,
      );

      if (nextReplies.length == 1) {
        if (nextReplies[0].id == replies.value[replies.value.length - 1].id) {
          return;
        }
      }

      if (context.mounted) {
        replies.value = [
          ...replies.value,
          ...nextReplies,
        ];

        replyText.value = '';
        replyController.clear();
      }
    }

    void getReplies() async {
      assert(feed.value != null, 'feed should not be null');

      replies.value = [];

      var result = await ReplyRepository.instance.getMany(
        type: ReplyType.feed,
        ref: feed.value!.ref,
      );

      if (context.mounted) {
        replies.value = result;
      }
    }

    void deleteReply(ReplyModel reply, int index) {
      alertDialog.confirm(
        context,
        title: t.deleteReply,
        content: t.deleteReplyHint,
        showCancelButton: true,
        confirmButtonBackgroundColor: AppColors.role.danger,
        onPress: () async {
          try {
            await ReplyRepository.instance.remove(reply.id);

            if (context.mounted) {
              replies.value =
                  replies.value.where((r) => r.id != reply.id).toList();

              extra?.onReplyDeleted?.call(reply);
            }
          } catch (err) {
            logger.e('deleteReply err: $err');
          }
        },
      );
    }

    useEffect(() {
      Future<void> getCommunity() async {
        var result = await CommunityRepository.instance.getWithId(
          feed.value!.communityRef.id,
        );

        if (result != null) {
          community.value = result;
        }
      }

      if (feed.value != null) {
        getReplies();
        getCommunity();
      }

      return null;
    }, [feed.value]);

    Future<void> submitReply(String text) async {
      assert(feed.value != null, 'feed should not be null');

      loading.value = true;
      if (replyText.value.isEmpty) return;

      try {
        var user = General.instance.checkAuth();

        var replyId = await ReplyRepository.instance.addToFeed(
          reply: replyText.value,
          feedId: feed.value!.id,
        );

        if (context.mounted) {
          var newReply = ReplyModel(
            id: replyId,
            reply: replyText.value,
            createdAt: DateTime.now(),
            feedRef: feed.value!.ref,
            writerRef: FirestoreConfig.userColRef.doc(user.uid),
          );

          replies.value = [newReply, ...replies.value];
          replyText.value = '';
          replyController.clear();
          extra?.onReplyAdded?.call(newReply);
        }
      } on UserNotSignedInException {
        if (context.mounted) {
          snackbar.alert(context, t.exceptionNotSignedIn);
        }
      } finally {
        if (context.mounted) {
          loading.value = false;
        }
      }
    }

    Widget renderFeedHeader() {
      return community.value == null || feed.value == null
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4 + MediaQuery.of(context).padding.left,
              ),
              child: Stack(
                children: [
                  FeedListItem(
                    feed: feed.value!,
                    hideReply: true,
                    community: community.value,
                    onPressUpdate: () {
                      context.pushNamed(
                        AppRoutes.feedEdit.name,
                        queryParams: {'feedId': feed.value!.id},
                        extra: FeedEditArguments(
                          onUpdate: (result) {
                            if (context.mounted) {
                              if (result.feed != null) {
                                switch (result.action) {
                                  case FeedActions.edit:
                                    feed.value = result.feed!;
                                    break;
                                  case FeedActions.delete:
                                    context.pop();
                                    break;
                                  // no-ops
                                  case FeedActions.add:
                                  default:
                                    break;
                                }
                              }
                            }
                          },
                        ),
                      );
                    },
                    onBanUser: () => General.instance.banUser(
                        context: context, userId: feed.value!.writerRef.id),
                    onReport: () => General.instance
                        .reportContent(context: context, feed: feed.value),
                    onTapPhoto: (photo, index) => context.pushNamed(
                      AppRoutes.pictureDetails.name,
                      extra: PictureDetailsArguments(
                        imageUrls: feed.value!.picture,
                        selectedIndex: index,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 32,
                    child: Row(children: [
                      Text(
                        t.reply,
                        style: Heading5TextStyle(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        numFormat.format(replies.value.length),
                        style: Body1TextStyle(),
                      ),
                    ]),
                  ),
                ],
              ),
            );
    }

    return Scaffold(
      appBar: AppBarBack(
        title: Text(
          feed.value?.description ?? '',
          maxLines: 1,
          style: TextStyle(
            color: AppColors.text.basic,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: FlatList(
              onRefresh: () async {
                getReplies();
              },
              listEmptyWidget: SizedBox(
                height: 140,
                child: Center(
                  child: Text(
                    t.noReply,
                    style: Body3TextStyle().merge(
                      TextStyle(color: AppColors.text.placeholder),
                    ),
                  ),
                ),
              ),
              onEndReached: () => fetchNext(replies.value.last.createdAt),
              listFooterWidget: const SizedBox(height: 48),
              data: replies.value,
              itemSeparatorWidget: const Divider(),
              buildItem: (item, index) {
                return Padding(
                  key: Key(item.id),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32 + MediaQuery.of(context).padding.left,
                    vertical: 4,
                  ),
                  child: ReplyListItemContainer(
                    reply: item,
                    onDelete: () {
                      if (context.mounted) {
                        item.isWriter ? deleteReply(item, index) : null;
                      }
                    },
                  ),
                );
              },
              listHeaderWidget: renderFeedHeader(),
            ),
          ),
          // Reply input
          Container(
            color: AppColors.bg.paper,
            width: MediaQuery.of(context).size.width,
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                EditText(
                  onSubmitted: submitReply,
                  textEditingController: replyController,
                  onChanged: (val) => replyText.value = val,
                  padding: const EdgeInsets.all(8),
                  maxLines: 3,
                  cursorColor: AppColors.text.basic,
                  textStyle: TextStyle(
                    color: AppColors.text.basic,
                    fontSize: 18,
                  ),
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 16, right: 60, top: 12, bottom: 12),
                    hintStyle: TextStyle(
                        fontSize: 18, color: AppColors.text.placeholder),
                    hintText: t.replyHint,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: AppColors.text.placeholder, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: AppColors.text.placeholder, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: AppColors.text.basic, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: AppColors.text.basic, width: 1),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  child: TextButton(
                    onPressed: replyText.value.isNotEmpty
                        ? () => submitReply(replyText.value)
                        : null,
                    child: Text(
                      t.reply,
                      style: TextStyle(
                        color: replyText.value.isNotEmpty
                            ? AppColors.text.basic
                            : AppColors.text.placeholder,
                      ),
                    ),
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
