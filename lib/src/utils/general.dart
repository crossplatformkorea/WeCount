import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

import '../models/feed_model.dart';
import '../providers/app_provider.dart';
import '../repositories/report_repository.dart';
import '../repositories/user_repository.dart';
import '../widgets/dialog_spinner.dart';
import 'alert_dialog/alert_dialog.dart';
import 'colors.dart';
import 'exceptions.dart';
import 'localization.dart';
import 'styles.dart';
import 'tools.dart';

class General {
  const General._();
  static General instance = const General._();

  void showDatePicker(
      BuildContext context, List<DateTime> dates, Function callback) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: AppColors.bg.paper,
            child: ListView.builder(
              itemBuilder: (context, index) {
                var datum =
                    '${dates[index].year}/${dates[index].month}/${dates[index].day}';
                return SizedBox(
                  child: TextButton(
                    onPressed: () {
                      // callback(datum);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 64.0,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Text(
                              datum,
                              style: Body1TextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: dates.length,
            ),
          );
        });
  }

  Future<void> launchURL(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return;
    }

    throw 'Could not launch $url';
  }

  User checkAuth() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw UserNotSignedInException();
    }

    return user;
  }

  Future<XFile?> chooseImage(
      {ImageSource imageSource = ImageSource.gallery, String? fileName}) async {
    var picker = ImagePicker();

    try {
      var imgFile = await picker.pickImage(source: imageSource);

      return imgFile;
    } catch (err) {
      logger.e(err);
      return null;
    }
  }

  Future<CroppedFile?> generateCroppedImage(
          BuildContext context, String sourcePath) =>
      ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        maxHeight: 512,
        maxWidth: 512,
        uiSettings: kIsWeb
            ? [
                WebUiSettings(
                  context: context,
                  presentStyle: CropperPresentStyle.dialog,
                  boundary: const CroppieBoundary(
                    width: 520,
                    height: 520,
                  ),
                  viewPort: const CroppieViewPort(
                    width: 480,
                    height: 480,
                  ),
                  enableExif: true,
                  enableZoom: true,
                  showZoomer: true,
                ),
              ]
            : null,
      );

  // File compressImage(File img, {int size = 500}) {
  //   Im.Image image = Im.decodeImage(img.readAsBytesSync())!;
  //   Im.Image smallerImage = Im.copyResize(image, width: size, height: size);
  //   return smallerImage as File;
  // }

  void showDialogSpinner(
    BuildContext context, {
    String? text,
    TextStyle? textStyle,
  }) {
    var t = localization(context);

    showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
              data: ThemeData(dialogBackgroundColor: AppColors.bg.paper),
              child: DialogSpinner(
                textStyle: TextStyle(
                  color: AppColors.text.primary,
                ).merge(textStyle),
                text: text ?? t.loading,
              ));
        });
  }

  void banUser({
    required BuildContext context,
    required String userId,
  }) {
    var t = localization(context);

    alertDialog.confirm(
      context,
      title: t.banUser,
      content: t.banUserHint,
      confirmButtonBackgroundColor: AppColors.role.danger,
      confirmTextColor: AppColors.text.primary,
      showCancelButton: true,
      onPress: () async {
        var result = await UserRepository.instance.addToBannedUsers(userId);

        if (result && context.mounted) {
          var userState = Provider.of<AppProvider>(context, listen: false);
          userState.addBannedUserId(userId: userId);

          Navigator.of(context).pop();

          alertDialog.confirm(
            context,
            title: t.banUserSuccess,
            content: t.banUserSuccessHint,
          );
        }
      },
    );
  }

  void reportContent({
    required BuildContext context,
    FeedModel? feed,
  }) {
    var t = localization(context);

    if (feed != null) {
      alertDialog.confirm(
        context,
        title: t.reportFeed,
        content: t.reportFeedHint,
        showCancelButton: true,
        confirmButtonBackgroundColor: AppColors.role.danger,
        confirmTextColor: AppColors.text.primary,
        onPress: () async {
          var result = await ReportRepository.instance.report(feed: feed);

          if (result && context.mounted) {
            Navigator.of(context).pop();

            alertDialog.confirm(
              context,
              title: t.reportFeedSuccess,
              content: t.reportFeedSuccessHint,
            );
          }
        },
      );

      return;
    }
  }

  bool isUserOwner({
    required BuildContext context,
    required String ownerId,
  }) {
    if (ownerId.isEmpty) return false;

    try {
      var user = checkAuth();

      return ownerId == user.uid;
    } catch (err) {
      logger.e(err);
      return false;
    }
  }
}
