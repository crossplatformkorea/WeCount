import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../repositories/user_repository.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'images.dart';

/// Here are two main items to note:
/// 1. [UserListItem]: The widget that is used to display a user with [UserModel].
/// 2. [UserListItemContainer]: The widget that uses `userRef` to fetch the user then render [UserListItem].

enum UserListItemType { list }

typedef BanUserCallback = void Function(String userId);

class UserListItem extends HookWidget {
  const UserListItem({
    super.key,
    required this.user,
    this.isFollowing = false,
    this.padding = const EdgeInsets.all(24),
    this.numOfShares = -1,
    this.onTap,
    this.type = UserListItemType.list,
    this.isUserItem = false,
    this.onPressFollow,
    this.onDelete,
    this.onReport,
    this.onBanUser,
  });
  final EdgeInsets padding;
  final double numOfShares;
  final UserModel user;
  final bool isFollowing;
  final GestureTapCallback? onTap;
  final UserListItemType type;
  final bool isUserItem;
  final Function? onPressFollow;
  final Function? onDelete;
  final Function? onReport;
  final Function? onBanUser;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case UserListItemType.list:
        return ListTile(
          contentPadding: padding,
          onTap: onTap,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ImageOnNetwork(
                    width: 50,
                    height: 50,
                    borderRadius: 25,
                    imageURL: user.photoUrl ?? user.thumbUrl ?? '',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.displayName,
                              style: TextStyle(
                                  color: AppColors.text.basic,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add,
                                size: 14,
                                color: AppColors.text.placeholder,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                numFormat.format(user.followerCount),
                                style: TextStyle(
                                    color: AppColors.text.placeholder,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // End widget
              Row(
                children: [
                  onDelete != null
                      ? TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                          ),
                          onPressed: () => onDelete?.call(),
                          child: Icon(
                            color: AppColors.role.danger,
                            Icons.delete_outline,
                            size: 16,
                          ),
                        )
                      : const SizedBox(),

                  /// 팔로우 버튼
                  onPressFollow != null
                      ? InkWell(
                          onTap: () => onPressFollow!.call(),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(children: [
                              Icon(
                                isFollowing
                                    ? Icons.person_add_alt_rounded
                                    : Icons.person_add_alt_outlined,
                                size: 16,
                                color: isFollowing
                                    ? AppColors.role.warning
                                    : AppColors.text.basic,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isFollowing ? '팔로잉' : '팔로우',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isFollowing
                                      ? AppColors.role.warning
                                      : AppColors.text.basic,
                                ),
                              ),
                            ]),
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        );
    }
  }
}

class UserListItemContainer extends HookWidget {
  const UserListItemContainer({
    super.key,
    required this.userRef,
    this.showBanned = false,
    this.onTap,
    this.type = UserListItemType.list,
    this.isUserItem = false,
    this.onDelete,
    this.onReport,
    this.showFollowButton = false,
    this.onBanUser,
    this.padding,
  });
  final DocumentReference userRef;
  final bool showBanned;
  final GestureTapCallback? onTap;
  final UserListItemType type;
  final bool isUserItem;
  final Function? onDelete;
  final Function? onReport;
  final bool showFollowButton;
  final BanUserCallback? onBanUser;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    var isFollowingState = useState(false);

    useEffect(() {
      void checkIsFollowing() async {
        var isFollowing = await UserRepository.instance.isFollowing(userRef.id);
        if (context.mounted) {
          isFollowingState.value = isFollowing;
        }
      }

      checkIsFollowing();

      return null;
    }, []);

    return Consumer<AppProvider>(
      builder: (context, state, child) {
        var userIds = state.bannedUserIds;

        /// Do not show banned user's content
        if (!showBanned && userIds.contains(userRef.id)) {
          return const SizedBox();
        }

        return FutureBuilder(
          future: UserRepository.instance.getFromRef(userRef),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var user = snapshot.data as UserModel;

              return UserListItem(
                user: user,
                isFollowing: isFollowingState.value,
                isUserItem: isUserItem,
                type: type,
                onTap: onTap,
                onDelete: onDelete,
                onBanUser: onBanUser != null ? () => onBanUser!(user.id) : null,
                onReport: onReport,
                padding: padding ?? const EdgeInsets.all(24),
              );
            }

            return ListTile(
              contentPadding: padding ?? const EdgeInsets.all(24),
            );
          },
        );
      },
    );
  }
}
