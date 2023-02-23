import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reply_model.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';

enum ReplyType { feed, reply }

abstract class IReplyRepository {
  Future<List<ReplyModel>> getMany({
    required DocumentReference ref,
    ReplyType type,
    startAfter,
    String searchText,
    int size,
  });

  DocumentReference getRef(String id);
  Future<ReplyModel?> getOne(String id);
  Future<ReplyModel?> getWithRef(DocumentReference ref);

  Future<String> addToFeed({required String reply, required String feedId});

  Future<String> addToReply({
    required String reply,
    required String replyId,
    required DocumentReference? feedRef,
  });

  /// Soft deletion
  Future<void> remove(String id);

  /// Permanently delete
  Future<void> delete(String id);

  Future<void> like(String id, bool shouldLike);
  Future<void> dislike(String id, bool shouldDislike);
}

class ReplyRepository implements IReplyRepository {
  const ReplyRepository._();
  static ReplyRepository instance = const ReplyRepository._();

  @override
  Future<List<ReplyModel>> getMany({
    /// The reference to the feed or reply.
    ///
    /// This is judged by the [type] parameter.
    required DocumentReference ref,
    ReplyType type = ReplyType.feed,
    startAfter,
    String searchText = '',
    int size = 10,
  }) async {
    var query = FirestoreConfig.replyColRef
        .withConverter<ReplyModel>(
          fromFirestore: (snapshot, _) =>
              ReplyModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (reply, _) => reply.toJson(),
        )
        .limit(size)
        .where('deletedAt', isNull: true);

    query = type == ReplyType.feed
        ? query.where('feedRef', isEqualTo: ref)
        : query.where('replyRef', isEqualTo: ref);

    query = searchText.isEmpty
        ? query.orderBy('createdAt', descending: true)
        : query
            .where('reply', isGreaterThanOrEqualTo: searchText.toUpperCase())
            .where('reply',
                isLessThanOrEqualTo: '${searchText.toUpperCase()}\uf8ff')
            .orderBy('reply', descending: false)
            .orderBy('createdAt', descending: true);

    query = startAfter != null ? query.startAfter([startAfter]) : query;
    var snap = await query.get();

    return snap.docs.map((e) => e.data()).toList();
  }

  @override
  DocumentReference getRef(String id) {
    return FirestoreConfig.replyColRef.doc(id);
  }

  @override
  Future<ReplyModel?> getOne(String id) async {
    var doc = FirestoreConfig.replyColRef.doc(id).withConverter<ReplyModel>(
          fromFirestore: (snapshot, _) =>
              ReplyModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (community, _) => community.toJson(),
        );

    var snap = await doc.get();

    if (!snap.exists || snap.data()!.deletedAt != null) null;
    return snap.data();
  }

  @override
  Future<ReplyModel?> getWithRef(DocumentReference ref) async {
    var doc = ref.withConverter<ReplyModel>(
      fromFirestore: (snapshot, _) =>
          ReplyModel.fromJson(snapshot.data() ?? {}),
      toFirestore: (community, _) => community.toJson(),
    );

    var snap = await doc.get();

    if (!snap.exists || snap.data()!.deletedAt != null) null;
    return snap.data();
  }

  @override
  Future<String> addToFeed(
      {required String reply, required String feedId}) async {
    var user = General.instance.checkAuth();
    var replyRef = FirestoreConfig.replyColRef.doc();
    var userRef = FirestoreConfig.userColRef.doc(user.uid);
    var feedRef = FirestoreConfig.feedColRef.doc(feedId);
    var batch = FirebaseFirestore.instance.batch();

    batch.set(replyRef, {
      'id': replyRef.id,
      'reply': reply,
      'writerRef': userRef,
      'feedRef': feedRef,
      'likeCount': 0,
      'dislikeCount': 0,
      'replyCount': 0,
      'createdAt': DateTime.now(),
      'updatedAt': null,
      'deletedAt': null,
    });

    batch.update(feedRef, {'replyCount': FieldValue.increment(1)});
    await batch.commit();
    return replyRef.id;
  }

  @override
  Future<String> addToReply({
    required String reply,
    required String replyId,
    DocumentReference? feedRef,
  }) async {
    var user = General.instance.checkAuth();
    var replyRef = FirestoreConfig.replyColRef.doc();
    var parentReplyRef = FirestoreConfig.replyColRef.doc(replyId);
    var userRef = FirestoreConfig.userColRef.doc(user.uid);
    var feedRef = FirestoreConfig.feedColRef.doc(replyId);
    var batch = FirebaseFirestore.instance.batch();

    batch.set(replyRef, {
      'id': replyRef.id,
      'reply': reply,
      'replyRef': parentReplyRef,
      'writerRef': userRef,
      'feedRef': feedRef,
      'likeCount': 0,
      'dislikeCount': 0,
      'replyCount': 0,
      'createdAt': DateTime.now(),
      'updatedAt': null,
      'deletedAt': null,
    });

    batch.update(parentReplyRef, {'replyCount': FieldValue.increment(1)});
    await batch.commit();
    return replyRef.id;
  }

  @override
  Future<void> remove(String id) async {
    var user = General.instance.checkAuth();
    var userRef = FirestoreConfig.userColRef.doc(user.uid);
    var replyRef = FirestoreConfig.replyColRef.doc(id);
    var reply = await getWithRef(replyRef);
    var replyDoc = await replyRef.get();

    if (reply != null) {
      var batch = FirebaseFirestore.instance.batch();

      if (replyDoc.exists) {
        batch.update(reply.feedRef!, {'replyCount': FieldValue.increment(-1)});
      }

      batch.set(
        replyRef,
        {'deletedAt': DateTime.now()},
        SetOptions(merge: true),
      );

      batch.update(userRef, {'replyCount': FieldValue.increment(-1)});

      await batch.commit();
    }
  }

  @override
  Future<void> delete(String id) async {
    var user = General.instance.checkAuth();
    var userRef = FirestoreConfig.userColRef.doc(user.uid);
    var replyRef = FirestoreConfig.replyColRef.doc(id);
    var reply = await getWithRef(replyRef);
    var replyDoc = await replyRef.get();

    if (reply != null) {
      var batch = FirebaseFirestore.instance.batch();

      if (replyDoc.exists) {
        batch.update(reply.feedRef!, {'replyCount': FieldValue.increment(-1)});
      }

      batch.update(userRef, {'replyCount': FieldValue.increment(-1)});
      batch.delete(replyRef);

      await batch.commit();
    }
  }

  @override
  Future<void> like(String id, bool shouldLike) async {
    var currentUser = General.instance.checkAuth();

    var replyUserLikeDoc = await FirestoreConfig.replyColRef
        .doc(id)
        .collection('likes')
        .doc(currentUser.uid)
        .get();

    var replyUserDislikeDoc = await FirestoreConfig.replyColRef
        .doc(id)
        .collection('dislikes')
        .doc(currentUser.uid)
        .get();

    var batch = FirebaseFirestore.instance.batch();

    if (shouldLike) {
      // 1. Add likes to user
      // 1-1. Remove dislikes from user if exists
      batch.delete(FirestoreConfig.userColRef
          .doc(currentUser.uid)
          .collection('dislikes')
          .doc(id));

      // 1-2. Add likes to user
      batch.set(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('likes')
            .doc(id),
        {
          'feedRef': null,
          'replyRef': FirestoreConfig.replyColRef.doc(id),
          'createdAt': DateTime.now(),
        },
      );

      // 2. Add likes to reply
      // 2-1. Remove dislikes from reply if exists

      if (replyUserDislikeDoc.exists) {
        batch.set(
          FirestoreConfig.replyColRef.doc(id),
          {'dislikeCount': FieldValue.increment(-1)},
          SetOptions(merge: true),
        );

        batch.delete(replyUserDislikeDoc.reference);
      }

      // 2-2. Remove likes from reply if exists

      if (!replyUserLikeDoc.exists) {
        batch.set(
          FirestoreConfig.replyColRef.doc(id),
          {'likeCount': FieldValue.increment(1)},
          SetOptions(merge: true),
        );

        batch.delete(replyUserLikeDoc.reference);
      }

      batch.set(
        replyUserLikeDoc.reference,
        {
          'userRef': FirestoreConfig.userColRef.doc(currentUser.uid),
          'createdAt': DateTime.now(),
        },
      );

      await batch.commit();

      return;
    }

    // Unlike reply
    // 1. Delete likes from user
    batch.delete(FirestoreConfig.userColRef
        .doc(currentUser.uid)
        .collection('likes')
        .doc(id));

    // 2. Delete likes from reply
    if (replyUserLikeDoc.exists) {
      batch.set(
        FirestoreConfig.replyColRef.doc(id),
        {'likeCount': FieldValue.increment(-1)},
        SetOptions(merge: true),
      );
    }

    batch.delete(replyUserLikeDoc.reference);

    await batch.commit();
  }

  @override
  Future<void> dislike(String id, bool shouldDislike) async {
    var currentUser = General.instance.checkAuth();

    var replyUserLikeDoc = await FirestoreConfig.replyColRef
        .doc(id)
        .collection('likes')
        .doc(currentUser.uid)
        .get();

    var replyUserDislikeDoc = await FirestoreConfig.replyColRef
        .doc(id)
        .collection('dislikes')
        .doc(currentUser.uid)
        .get();

    var batch = FirebaseFirestore.instance.batch();

    if (shouldDislike) {
      // 1. Add dislikes to user
      // 1-1. Remove likes from user if exists
      batch.delete(FirestoreConfig.userColRef
          .doc(currentUser.uid)
          .collection('likes')
          .doc(id));

      // 1-2. Add dislikes to user
      batch.set(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('dislikes')
            .doc(id),
        {
          'feedRef': null,
          'replyRef': FirestoreConfig.replyColRef.doc(id),
          'createdAt': DateTime.now(),
        },
      );

      // 2. Add dislikes to reply
      // 2-1. Remove likes from reply if exists

      if (replyUserLikeDoc.exists) {
        batch.set(
          FirestoreConfig.replyColRef.doc(id),
          {'likeCount': FieldValue.increment(-1)},
          SetOptions(merge: true),
        );

        batch.delete(replyUserLikeDoc.reference);
      }

      // 2-2. Remove dislikes from reply if exists

      if (!replyUserDislikeDoc.exists) {
        batch.set(
          FirestoreConfig.replyColRef.doc(id),
          {'dislikeCount': FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      }

      batch.set(
        replyUserDislikeDoc.reference,
        {
          'userRef': FirestoreConfig.userColRef.doc(currentUser.uid),
          'createdAt': DateTime.now(),
        },
      );

      return;
    }

    // Unlike reply
    // 1. Delete dislikes from user
    batch.delete(FirestoreConfig.userColRef
        .doc(currentUser.uid)
        .collection('dislikes')
        .doc(id));

    // 2. Delete dislikes from reply
    if (replyUserLikeDoc.exists) {
      batch.set(
        FirestoreConfig.replyColRef.doc(id),
        {'dislikeCount': FieldValue.increment(-1)},
        SetOptions(merge: true),
      );
    }

    batch.delete(replyUserDislikeDoc.reference);

    await batch.commit();
  }
}
