import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../routes.dart';
import '../models/community_model.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../screens/picture_details.dart';
import '../utils/colors.dart';
import '../utils/firestore_config.dart';
import '../utils/localization.dart';
import '../utils/storage.dart';
import '../utils/styles.dart';
import 'images.dart';
import 'user_card.dart';

class CommunityCard extends HookWidget {
  const CommunityCard({
    super.key,
    required this.community,
    this.hideAmount = false,
    this.hideUser = false,
    this.onUploadPicture,
    this.userDisplayNameMaxWidth = 200,
  });

  final CommunityModel community;
  final bool hideAmount;
  final bool hideUser;
  final Function(ImageUrlSets)? onUploadPicture;
  final double userDisplayNameMaxWidth;

  @override
  Widget build(BuildContext context) {
    var owner = useState<UserModel?>(null);
    var t = localization(context);
    var currencyFormat = NumberFormat.simpleCurrency(
      locale: community.currency.name == 'usd' ? 'en_US' : 'ko_KR',
    );

    /// This method is used to upload a picture to the community.
    /// This is available when community is editing.
    Future<void> uploadPicture() async {
      var communityImages = await Storage.instance.uploadImageSets(
        context: context,
        photoRef: Storage.instance.getCommunityPhotoRef(community.id),
        thumbRef: Storage.instance.getCommunityThumbRef(community.id),
        imageSource: ImageSource.gallery,
      );

      if (communityImages != null) {
        onUploadPicture?.call(communityImages);
      }
    }

    useEffect(() {
      Future<void> getOwner() async {
        var user = await UserRepository.instance.getFromRef(
          community.ownerRef ??
              FirestoreConfig.userColRef.doc(
                FirebaseAuth.instance.currentUser?.uid,
              ),
        );

        if (context.mounted) {
          owner.value = user;
        }
      }

      getOwner();

      return null;
    }, [community.ownerRef]);

    var communityTextColor = getFontColorForBackground(community.color);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.bg.paper.withOpacity(.5),
            blurRadius: 142,
            blurStyle: BlurStyle.solid,
          ),
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0.3,
            blurStyle: BlurStyle.outer,
            color: AppColors.bg.basic.withOpacity(.5),
          ),
        ],
        color: community.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Community Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                community.title,
                                maxLines: 2,
                                style: Body1TextStyle().merge(
                                  TextStyle(
                                    color: communityTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, top: 4, right: 20),
                            child: SelectableText(
                              community.description ?? '',
                              maxLines: 3,
                              style: Body2TextStyle().merge(
                                TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: communityTextColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        !hideUser
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  UserCard(
                                    textColor: communityTextColor,
                                    maxWidth: userDisplayNameMaxWidth,
                                    user: owner.value,
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),

                  /// Community Icon
                  !hideUser
                      ? Stack(
                          children: [
                            InkWell(
                              onTap: onUploadPicture != null
                                  ? uploadPicture
                                  : community.photoUrl != null &&
                                          community.photoUrl!.isNotEmpty
                                      ? () => context.pushNamed(
                                            AppRoutes.pictureDetails.name,
                                            extra: PictureDetailsArguments(
                                              imageUrls: [community.photoUrl!],
                                            ),
                                          )
                                      : null,
                              child: Ink(
                                child: ImageOnNetwork(
                                  imageURL: community.thumbUrl ??
                                      community.photoUrl ??
                                      '',
                                  width: 84,
                                  height: 84,
                                  placeholder: Container(
                                    decoration: BoxDecoration(
                                      color: community.color.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: communityTextColor,
                                        width: 0.3,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        community.title.isEmpty
                                            ? ''
                                            : community.title.substring(0, 1),
                                        style: TextStyle(
                                          color: communityTextColor,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (onUploadPicture != null)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: communityTextColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.upload,
                                    color: community.color,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),

            /// Footer
            hideAmount
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            t.currentBalance,
                            style: TextStyle(
                              fontSize: 18,
                              color: communityTextColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(
                              community.totalIncome - community.totalConsume,
                            ),
                            style: TextStyle(
                              fontSize: 28,
                              color: communityTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
