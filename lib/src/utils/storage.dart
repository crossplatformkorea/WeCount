import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/colors.dart';
import '../utils/general.dart';
import 'localization.dart';
import 'snackbar.dart';
import 'tools.dart';
import 'utils.dart';

class StorageFile {
  StorageFile({
    required this.file,
    required this.name,
    required this.data,
  });

  final File file;
  final String name;
  final Uint8List data;
}

class ImageUrlSets {
  ImageUrlSets({
    required this.photoUrl,
    this.thumbUrl,
  });
  String photoUrl;
  String? thumbUrl;
}

class Storage {
  Storage._();
  static Storage instance = Storage._();

  final _ref = FirebaseStorage.instance.ref();

  Reference getUserPhotoRef(String id) => _ref.child('users/$id');
  Reference getUserThumbRef(String userId) =>
      _ref.child('users/thumbnails/$userId');
  Reference getCommunityPhotoRef(String id) => _ref.child('communities/$id');
  Reference getCommunityThumbRef(String id) =>
      _ref.child('communities/thumbnails/$id');
  Reference getFeedRef(String id) => _ref.child('feeds/$id');

  Future<ImageUrlSets?> uploadImageSets({
    required BuildContext context,
    required Reference photoRef,
    required Reference thumbRef,
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    try {
      var imageFile =
          await General.instance.chooseImage(imageSource: imageSource);

      if (imageFile == null) return null;

      var file = StorageFile(
        data: await imageFile.readAsBytes(),
        name: imageFile.name,
        file: File(imageFile.path),
      );

      if (kIsWeb) {
        await photoRef.putData(file.data);
      } else {
        await photoRef.putFile(file.file);
      }

      /// Generate cropped image and upload it to firebase storage if possible.
      if (context.mounted) {
        var genCroppedImage = await General.instance
            .generateCroppedImage(context, imageFile.path);

        if (genCroppedImage != null) {
          var croppedFile = StorageFile(
            file: File(genCroppedImage.path),
            name: imageFile.name,
            data: await genCroppedImage.readAsBytes(),
          );

          if (kIsWeb) {
            await thumbRef.putData(croppedFile.data);
          } else {
            await thumbRef.putFile(croppedFile.file);
          }
        }

        return ImageUrlSets(
          photoUrl: await photoRef.getDownloadURL(),
          thumbUrl:
              genCroppedImage != null ? await thumbRef.getDownloadURL() : null,
        );
      }

      return ImageUrlSets(
        photoUrl: await photoRef.getDownloadURL(),
      );
    } catch (err) {
      logger.e(err);
      snackbar.alert(context, localization(context).noPhotoPermission,
          backgroundColor: AppColors.role.warning,
          textStyle: TextStyle(color: AppColors.text.contrast));

      return null;
    }
  }

  Future<void> deleteFromURL(String url) {
    return FirebaseStorage.instance.refFromURL(url).delete();
  }

  Future<List<String>> uploadFeedImages(
      BuildContext context, String feedId, List<String> picture) async {
    var feedRef = getFeedRef(feedId);
    var futures = <Future>[];
    var downloadURLs = <String>[];

    try {
      for (var photo in picture) {
        var imageFile = File(photo);

        var uploadRef = feedRef.child(
            '${dateTimeFormat.format(DateTime.now())}_${imageFile.path.split('/').last}');

        if (kIsWeb) {
          var imageData = await XFile(photo).readAsBytes();
          futures.add(uploadRef.putData(imageData));
        } else {
          var file = StorageFile(
            data: await imageFile.readAsBytes(),
            name: imageFile.path.split('/').last,
            file: File(imageFile.path),
          );

          futures.add(uploadRef.putFile(file.file));
        }
      }

      var result = await Future.wait(futures);

      for (var res in result) {
        var downloadURL = await res.ref.getDownloadURL();
        downloadURLs.add(downloadURL);
      }

      return downloadURLs;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}
