import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/converter.dart';
import '../utils/exceptions.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';
import '../utils/tools.dart';

part 'reply_model.freezed.dart';
part 'reply_model.g.dart';

@freezed
class ReplyModel with _$ReplyModel {
  const ReplyModel._();

  const factory ReplyModel({
    /// Reply ID
    required String id,

    /// Reply
    required String reply,

    /// Like count
    @Default(0) int likeCount,

    /// Dislike count
    @Default(0) int dislikeCount,

    /// replies count
    @Default(0) int replyCount,

    /// Dates
    @ServerTimestampConverter() required DateTime createdAt,
    @ServerTimestampConverter() DateTime? updatedAt,
    @ServerTimestampConverter() DateTime? deletedAt,

    /// Replier
    @DocumentRefConverter() required DocumentReference writerRef,

    /// Reply to feed
    @DocumentRefConverter() DocumentReference? feedRef,

    /// Replying to reply
    @DocumentRefConverter() DocumentReference? replyRef,
  }) = _ReplyModel;

  factory ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyModelFromJson(json);

  Future<bool> hasLikedItem() async {
    try {
      var user = General.instance.checkAuth();

      var likeDoc = await FirestoreConfig.replyColRef
          .doc(id)
          .collection('likes')
          .doc(user.uid)
          .get();

      return likeDoc.exists;
    } on UserNotSignedInException {
      logger.d('[hasLikedItem]: user not signed in');
      return false;
    }
  }

  Future<bool> hasDislikedItem() async {
    try {
      var user = General.instance.checkAuth();

      var dislikeDoc = await FirestoreConfig.replyColRef
          .doc(id)
          .collection('dislikes')
          .doc(user.uid)
          .get();

      return dislikeDoc.exists;
    } on UserNotSignedInException {
      logger.d('[hasDislikedItem]: user not signed in');
      return false;
    }
  }

  DocumentReference get ref => FirestoreConfig.replyColRef.doc(id);

  bool get isWriter => FirebaseAuth.instance.currentUser == null
      ? false
      : writerRef ==
          FirestoreConfig.userColRef
              .doc(FirebaseAuth.instance.currentUser!.uid);
}
