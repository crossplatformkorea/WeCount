import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import '../models/community_model.dart';
import '../models/feed_model.dart';
import '../providers/app_provider.dart';
import '../repositories/community_repository.dart';
import '../repositories/feed_repository.dart';
import '../utils/colors.dart';
import '../utils/general.dart';
import '../utils/localization.dart';
import '../utils/styles.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../widgets/community_card.dart';
import '../widgets/feed_list_item.dart';
import 'community_edit.dart';
import 'feed_edit.dart';
import 'picture_details.dart';

class Feeds extends HookWidget {
  const Feeds({super.key, this.initialCommunity});

  final CommunityModel? initialCommunity;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppProvider>(context, listen: false);
    var t = localization(context);
    var community = useState<CommunityModel?>(initialCommunity);
    var loading = useState(false);
    var feeds = useState<List<FeedModel>>([]);
    var count = useState(0);
    var searchText = useState('');
    var lastListId = useState<dynamic>(null);

    var isOwner = FirebaseAuth.instance.currentUser != null &&
        community.value != null &&
        community.value!.isOwner;

    Future<void> fetchFeeds(String text) async {
      loading.value = true;
      feeds.value = [];

      var result = await FeedRepository.instance
          .getMany(searchText: text, communityRef: community.value?.ref);

      if (context.mounted) {
        feeds.value = result;
        count.value = result.length;
      }
    }

    Future<void> fetchNext({
      startAfter,
      text,
    }) async {
      if (lastListId.value == startAfter) return;

      lastListId.value = startAfter;
      loading.value = true;

      var nextCommunities = await FeedRepository.instance.getMany(
          startAfter: startAfter,
          searchText: text.value,
          communityRef: community.value?.ref);

      if (context.mounted) {
        feeds.value += nextCommunities;
        loading.value = false;
        count.value = feeds.value.length;
      }
    }

    useEffect(() {
      fetchFeeds(searchText.value);

      return null;
    }, [searchText.value]);

    /// Handle updates on community
    var communityEditArgs = CommunityEditArguments(
      onUpdate: (result) {
        if (context.mounted) {
          switch (result.action) {
            case CommunityActions.edit:
              community.value = result.community;
              break;
            // no-ops
            case CommunityActions.add:
            case CommunityActions.delete:
            default:
              break;
          }
        }
      },
    );

    Future<void> editCommunity() async {
      if (community.value != null) {
        context.pushNamed(
          AppRoutes.communityEdit.name,
          queryParams: {
            'id': community.value!.id,
          },
          extra: communityEditArgs,
        );
      }
    }

    /// Handle updates on feed
    Future<void> updateFeed(FeedModel item, int index) async {
      loading.value = true;

      context.pushNamed(
        AppRoutes.feedEdit.name,
        queryParams: {
          'feedId': item.id,
        },
        extra: FeedEditArguments(
          onUpdate: (result) {
            if (context.mounted) {
              if (result.feed != null) {
                switch (result.action) {
                  case FeedActions.edit:
                    feeds.value[index] = result.feed!;
                    break;
                  case FeedActions.delete:
                    feeds.value.removeAt(index);
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
    }

    Future<void> createFeed() async {
      assert(community.value != null,
          'Community should not be null when creating feed!');

      context.pushNamed(
        AppRoutes.feedCreate.name,
        queryParams: {
          'communityId': community.value!.id,
        },
        extra: FeedEditArguments(
          onUpdate: (result) {
            if (context.mounted) {
              if (result.feed != null) {
                feeds.value = [result.feed!, ...feeds.value];
              }
            }
          },
        ),
      );
    }

    Widget communityHederWidget() {
      if (initialCommunity == null) return const SizedBox();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: CommunityCard(community: community.value!),
      );
    }

    var filteredFeeds = feeds.value
        .where((feed) => !appState.bannedUserIds.contains(feed.writerRef.id))
        .where((e) => e.isWriter || e.visibility)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg.paper,
      appBar: context.canPop()
          ? AppBarBack(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      community.value?.title ?? '',
                      style: Heading4TextStyle(),
                    ),
                  ),
                  isOwner
                      ? IconButton(
                          padding: const EdgeInsets.only(top: 2),
                          onPressed: editCommunity,
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.text.basic,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              actions: isOwner
                  ? [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Button(
                          text: t.writeFeed,
                          height: 28,
                          onPress: community.value != null ? createFeed : null,
                          backgroundColor: AppColors.role.primaryLight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          margin: const EdgeInsets.only(right: 12),
                        ),
                      ),
                    ]
                  : null,
            )
          : null,
      body: SafeArea(
        child: FlatList(
          listHeaderWidget: communityHederWidget(),
          buildItem: (item, index) {
            return Padding(
              padding: EdgeInsets.only(
                right: 12,
                left: 12,
                top: context.canPop() && index == 0 ? 0 : 24,
              ),
              child: FutureBuilder<CommunityModel?>(
                future: CommunityRepository.instance
                    .getWithId(item.communityRef.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FeedListItem(
                      feed: item,
                      onTap: () => context.pushNamed(
                        AppRoutes.feed.name,
                        queryParams: {'id': item.id},
                      ),
                      onTapCommunity: initialCommunity != null
                          ? null
                          : () => context.pushNamed(
                                AppRoutes.community.name,
                                queryParams: {
                                  'id': item.communityRef.id,
                                },
                              ),
                      community: snapshot.data as CommunityModel,
                      onPressUpdate:
                          item.isWriter ? () => updateFeed(item, index) : null,
                      onBanUser: () => General.instance
                          .banUser(context: context, userId: item.writerRef.id),
                      onReport: () => General.instance
                          .reportContent(context: context, feed: item),
                      onTapPhoto: (photo, index) => context.pushNamed(
                        AppRoutes.pictureDetails.name,
                        extra: PictureDetailsArguments(
                          imageUrls: item.picture,
                          selectedIndex: index,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          },
          data: filteredFeeds,
          onRefresh: () => fetchFeeds(searchText.value),
          onEndReached: () => fetchNext(
            startAfter: searchText.value.isEmpty
                ? feeds.value.last.createdAt
                : feeds.value.last.description,
            text: searchText,
          ),
          listFooterWidget: const SizedBox(height: 28),
          listEmptyWidget: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Center(
              child: Text(
                t.noFeeds,
                style: Body2TextStyle().merge(TextStyle(
                  color: AppColors.text.placeholder,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
