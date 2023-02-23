import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/converter.dart';
import '../utils/exceptions.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';
import 'community_model.dart';

part 'feed_model.freezed.dart';
part 'feed_model.g.dart';

enum FeedType {
  none,
  income,
  consume,
}

@freezed
class FeedModel with _$FeedModel {
  const FeedModel._();

  const factory FeedModel({
    required String id,
    required String description,
    @Default(0.0) double amount,
    @Default(true) bool visibility,
    @Default(CommunityCurrency.usd) CommunityCurrency currency,
    String? placeName,
    @Default([]) List<String> picture,
    @Default(FeedType.none) FeedType type,
    @Default(0) int likeCount,
    @Default(0) int dislikeCount,
    @Default(0) int replyCount,
    @DocumentRefConverter() required DocumentReference writerRef,
    @DocumentRefConverter() required DocumentReference communityRef,
    @ServerTimestampConverter() required DateTime createdAt,
    @TimestampNullableConverter() DateTime? updatedAt,
    @TimestampNullableConverter() DateTime? deletedAt,
  }) = _FeedModel;

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);

  DocumentReference get ref => FirestoreConfig.feedColRef.doc(id);

  bool get isWriter => FirebaseAuth.instance.currentUser == null
      ? false
      : writerRef ==
          FirestoreConfig.userColRef
              .doc(FirebaseAuth.instance.currentUser!.uid);

  Future<bool> hasLikedItem() async {
    try {
      var user = General.instance.checkAuth();

      var likeDoc = await FirestoreConfig.feedColRef
          .doc(id)
          .collection('likes')
          .doc(user.uid)
          .get();

      return likeDoc.exists;
    } on UserNotSignedInException {
      return false;
    }
  }

  Future<bool> hasDislikedItem() async {
    try {
      var user = General.instance.checkAuth();

      var dislikeDoc = await FirestoreConfig.feedColRef
          .doc(id)
          .collection('dislikes')
          .doc(user.uid)
          .get();

      return dislikeDoc.exists;
    } on UserNotSignedInException {
      return false;
    }
  }
}
