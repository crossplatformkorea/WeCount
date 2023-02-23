import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/feed_model.dart';
import '../models/reply_model.dart';
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
import '../widgets/app_bar.dart';
import '../widgets/edit_text.dart';
import '../widgets/reply_list_item.dart';

class ReplyArguments {
  ReplyArguments({
    required this.feed,
    this.onReplyAdded,
    this.onReplyDeleted,
  });

  final FeedModel feed;
  final Function(ReplyModel reply)? onReplyAdded;
  final Function(ReplyModel reply)? onReplyDeleted;
}

class Reply extends HookWidget {
  const Reply({
    super.key,
    required this.feedId,
    this.extra,
  });

  final String feedId;
  final ReplyArguments? extra;

  @override
  Widget build(BuildContext context) {
    var feed = useState<FeedModel?>(null);

    useEffect(() {
      Future<void> getFeed() async {
        var result = await FeedRepository.instance.getWithId(feedId);

        if (context.mounted && result != null) {
          feed.value = result;
        }
      }

      getFeed();

      return null;
    }, []);

    return _Reply(
      feed: feed.value,
      extra: extra,
    );
  }
}

class _Reply extends HookWidget {
  const _Reply({
    required this.feed,
    this.extra,
  });

  final FeedModel? feed;
  final ReplyArguments? extra;

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var replyController = useTextEditingController();
    var replies = useState<List<ReplyModel>>([]);
    var replyText = useState('');
    var loading = useState(false);
    var lastListId = useState<dynamic>(null);

    Future<void> fetchNext(startAfter) async {
      assert(feed != null, 'feed should not be null');

      if (lastListId.value == startAfter) return;

      lastListId.value = startAfter;
      loading.value = true;

      var nextReplies = await ReplyRepository.instance.getMany(
        type: ReplyType.feed,
        ref: feed!.ref,
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
      assert(feed != null, 'feed should not be null');

      replies.value = [];

      var result = await ReplyRepository.instance.getMany(
        type: ReplyType.feed,
        ref: feed!.ref,
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
      if (feed != null) {
        getReplies();
      }

      return null;
    }, [feed]);

    Future<void> submitReply(String text) async {
      assert(feed != null, 'feed should not be null');

      loading.value = true;
      if (replyText.value.isEmpty) return;

      try {
        var user = General.instance.checkAuth();

        var replyId = await ReplyRepository.instance.addToFeed(
          reply: replyText.value,
          feedId: feed!.id,
        );

        if (context.mounted) {
          var newReply = ReplyModel(
            id: replyId,
            reply: replyText.value,
            createdAt: DateTime.now(),
            feedRef: feed!.ref,
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

    return Scaffold(
      backgroundColor: AppColors.bg.basic,
      appBar: AppBarBack(
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            feed?.description ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Heading4TextStyle(),
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
              inverted: true,
              listEmptyWidget: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.bottom -
                    kToolbarHeight,
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
              data: replies.value,
              buildItem: (item, index) {
                return Padding(
                  key: Key(item.id),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16 + MediaQuery.of(context).padding.left),
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
              listHeaderWidget: replies.value.isNotEmpty
                  ? const SizedBox(height: 48)
                  : const SizedBox(),
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
