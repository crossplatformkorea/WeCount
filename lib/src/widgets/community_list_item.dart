import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_plus/share_plus.dart';

import '../models/community_model.dart';
import '../repositories/user_repository.dart';
import '../services/dynamic_link_service.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import 'button.dart';
import 'images.dart';

class CommunityListItem extends HookWidget {
  const CommunityListItem({
    super.key,
    required this.community,
    this.onPress,
  });
  final CommunityModel community;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    var t = localization(context);

    Future<void> shareLink() async {
      if (kIsWeb) {
        var webUrl = 'https://wecount.space/community?id=${community.id}';

        unawaited(Share.share(webUrl));
        return;
      }

      var link = 'community?id=${community.id}';

      var shortLink = await DynamicLinkService.instance.create(
        link: link,
        short: true,
      );

      unawaited(Share.share(shortLink));
    }

    Widget renderOwner() {
      return FutureBuilder(
        future: UserRepository.instance.getWithUID(community.ownerRef!.id),
        builder: (context, snapshot) {
          var owner = snapshot.data;

          if (snapshot.hasData) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ImageOnNetwork(
                    imageURL: owner!.thumbUrl ?? owner.photoUrl ?? '',
                    width: 40,
                    height: 40,
                    border: Border.all(color: AppColors.role.primary, width: 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.operator,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text.placeholder,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          owner.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text.basic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            );
          }

          return const SizedBox();
        },
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.bg.basic,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First row shows community data
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageOnNetwork(
                imageURL: community.thumbUrl ?? community.photoUrl ?? '',
                width: 84,
                height: 84,
                borderRadius: 20,
                placeholder: Container(
                  decoration: BoxDecoration(
                    color: community.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      community.title.isNotEmpty
                          ? community.title.substring(0, 1)
                          : '',
                      style: TextStyle(
                        color: getFontColorForBackground(community.color),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    SelectableText(
                      community.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Wrap(
                        children: [
                          Container(
                            constraints: const BoxConstraints(minHeight: 44),
                            child: SelectableText(
                              community.description ?? '',
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.text.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: shareLink,
                    padding: const EdgeInsets.only(bottom: 12, left: 18),
                    icon: Icon(
                      Icons.share,
                      size: 14,
                      color: AppColors.text.basic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 8),
            child: Divider(height: 1),
          ),
          // Second row shows members
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: renderOwner()),
                // TODO: Show members
                // Expanded(
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 94,
                //         child: Stack(
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.only(left: 0),
                //               child: ImageOnNetwork(
                //                 imageURL:
                //                     'https://avatars.githubusercontent.com/u/27461460?v=4',
                //                 width: 40,
                //                 height: 40,
                //                 border: Border.all(
                //                     color: AppColors.role.primary, width: 1),
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(left: 16),
                //               child: ImageOnNetwork(
                //                 imageURL:
                //                     'https://avatars.githubusercontent.com/u/20165741?v=4',
                //                 width: 40,
                //                 height: 40,
                //                 border: Border.all(
                //                     color: AppColors.role.primary, width: 1),
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(left: 32),
                //               child: ImageOnNetwork(
                //                 imageURL:
                //                     'https://avatars.githubusercontent.com/u/27461460?v=4',
                //                 width: 40,
                //                 height: 40,
                //                 border: Border.all(
                //                     color: AppColors.role.primary, width: 1),
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(left: 48),
                //               child: ImageOnNetwork(
                //                 imageURL:
                //                     'https://avatars.githubusercontent.com/u/29647600?s=200&v=4',
                //                 width: 40,
                //                 height: 40,
                //                 border: Border.all(
                //                     color: AppColors.role.primary, width: 1),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             'Members',
                //             style: TextStyle(
                //                 fontSize: 14, fontWeight: FontWeight.bold),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.only(top: 2),
                //             child: Wrap(
                //               children: [
                //                 Text(
                //                   '총 ${community.members.length}명',
                //                   maxLines: 3,
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       )
                //     ],
                //   ),
                // ),
                Button(
                  height: 40,
                  text: t.more,
                  buttonType: ButtonType.outline,
                  onPress: onPress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
