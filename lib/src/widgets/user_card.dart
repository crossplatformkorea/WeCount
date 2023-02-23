import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../routes.dart';
import '../models/user_model.dart';
import '../utils/colors.dart';
import '../utils/general.dart';
import '../utils/styles.dart';
import 'images.dart';

class UserCard extends HookWidget {
  const UserCard({
    super.key,
    required this.user,
    this.textColor,
    this.maxWidth = 120,
  });
  final UserModel? user;
  final Color? textColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: General.instance
              .isUserOwner(context: context, ownerId: user?.id ?? '')
          ? () => context.pushNamed(AppRoutes.profile.name)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: AppColors.bg.paper,
                child: ImageOnNetwork(
                  imageURL: user?.thumbUrl ?? user?.photoUrl ?? '',
                  height: 20,
                  width: 20,
                  borderRadius: 10,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.only(top: 2),
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(
                user?.displayName ?? '',
                overflow: TextOverflow.ellipsis,
                style: Body2TextStyle().merge(
                  TextStyle(
                    height: 1.0,
                    fontWeight: FontWeight.w400,
                    color: textColor,
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
