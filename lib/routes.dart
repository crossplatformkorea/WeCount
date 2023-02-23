import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'src/root.dart';
import 'src/screens/banned_users.dart';
import 'src/screens/communities.dart';
import 'src/screens/community.dart';
import 'src/screens/community_edit.dart';
import 'src/screens/feed.dart';
import 'src/screens/feed_edit.dart';
import 'src/screens/feeds.dart';
import 'src/screens/intro.dart';
import 'src/screens/picture_details.dart';
import 'src/screens/profile.dart';
import 'src/screens/reply.dart';
import 'src/widgets/not_found.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoutes {
  intro,
  community,
  communities,
  communityEdit,
  feed,
  feeds,
  feedCreate,
  feedEdit,
  reply,
  profile,
  bannedUsers,
  pictureDetails,
}

extension RoutesName on AppRoutes {
  String get name => describeEnum(this);

  /// Convert to `lower-snake-case` format.
  String get path {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result =
        name.replaceAllMapped(exp, (m) => '-${m.group(0)}').toLowerCase();
    return result;
  }

  /// Convert to `lower-snake-case` format with `/`.
  String get fullPath {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result =
        name.replaceAllMapped(exp, (m) => '-${m.group(0)}').toLowerCase();
    return '/$result';
  }
}

final routers = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.intro.fullPath,
  errorBuilder: (context, state) {
    return const NotFound();
  },
  routes: <RouteBase>[
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: AppRoutes.profile.name,
      path: AppRoutes.profile.fullPath,
      builder: (context, state) {
        return const Profile();
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: AppRoutes.bannedUsers.name,
      path: AppRoutes.bannedUsers.fullPath,
      builder: (context, state) {
        return const BannedUsers();
      },
    ),

    /// Below can't be used in deep link
    /// https://docs.page/csells/go_router/parameters#extra-parameter
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: AppRoutes.pictureDetails.name,
      path: AppRoutes.pictureDetails.fullPath,
      builder: (context, state) {
        var args = state.extra as PictureDetailsArguments;

        return PictureDetails(
          imageUrls: args.imageUrls,
          selectedIndex: args.selectedIndex,
        );
      },
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return Root(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          name: AppRoutes.intro.name,
          path: AppRoutes.intro.fullPath,
          builder: (context, state) {
            return const Intro();
          },
        ),
        GoRoute(
          name: AppRoutes.communities.name,
          path: AppRoutes.communities.fullPath,
          builder: (context, state) => const Communities(),
        ),
        GoRoute(
          name: AppRoutes.communityEdit.name,
          path: AppRoutes.communityEdit.fullPath,
          builder: (context, state) {
            var id = state.queryParams['id'];
            var extra = state.extra != null
                ? state.extra as CommunityEditArguments
                : null;

            return CommunityEdit(
              communityId: id,
              extra: extra,
            );
          },
        ),
        GoRoute(
          name: AppRoutes.community.name,
          path: AppRoutes.community.fullPath,
          builder: (context, state) {
            var id = state.queryParams['id'];
            if (id == null) {
              return const NotFound();
            }

            return Community(id: id);
          },
        ),
        GoRoute(
          name: AppRoutes.feed.name,
          path: AppRoutes.feed.fullPath,
          builder: (context, state) {
            var id = state.queryParams['id'];
            if (id == null) {
              return const NotFound();
            }

            return Feed(id: id);
          },
        ),
        GoRoute(
          name: AppRoutes.feeds.name,
          path: AppRoutes.feeds.fullPath,
          builder: (context, state) => const Feeds(),
        ),
        GoRoute(
          name: AppRoutes.feedCreate.name,
          path: AppRoutes.feedCreate.fullPath,
          builder: (context, state) {
            var communityId = state.queryParams['communityId'];
            var extra =
                state.extra != null ? state.extra as FeedEditArguments : null;

            return FeedEdit(
              communityId: communityId,
              extra: extra,
            );
          },
        ),
        GoRoute(
          name: AppRoutes.feedEdit.name,
          path: AppRoutes.feedEdit.fullPath,
          builder: (context, state) {
            var feedId = state.queryParams['feedId'];
            var extra =
                state.extra != null ? state.extra as FeedEditArguments : null;

            return FeedEdit(
              feedId: feedId,
              extra: extra,
            );
          },
        ),
        GoRoute(
          name: AppRoutes.reply.name,
          path: '${AppRoutes.reply.fullPath}/:feedId',
          builder: (context, state) {
            var id = state.params['feedId'] ?? '';
            var extra =
                state.extra != null ? state.extra as ReplyArguments : null;

            return Reply(feedId: id, extra: extra);
          },
        ),
      ],
    ),
  ],
);
