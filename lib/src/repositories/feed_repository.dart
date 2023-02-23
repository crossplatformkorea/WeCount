import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FieldValue, FirebaseFirestore, SetOptions;
import '../models/community_model.dart';
import '../models/feed_model.dart';
import '../utils/exceptions.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';

abstract class IFeedRepository {
  Future<List<FeedModel>> getMany({
    startAfter,
    String searchText,
    int size,

    /// Specify communityRef
    DocumentReference? communityRef,
  });

  Future<FeedModel?> getWithId(String id);
  Future<FeedModel?> getFromRef(DocumentReference ref);

  Future<FeedModel> edit({
    required CommunityModel community,
    required double amount,
    required String description,
    // Put [ref] to specify the document reference
    DocumentReference? ref,
    bool visibility = false,
    CommunityCurrency currency,

    /// When provided, the feed will be updated instead of created
    String? id,
    FeedType type = FeedType.none,
    List<String>? picture,
    String? placeName,
  });

  Future<bool> delete(FeedModel community);
  Future<void> like(String id, bool shouldLike);
  Future<void> dislike(String id, bool shouldDislike);
}

class FeedRepository implements IFeedRepository {
  const FeedRepository._();
  static FeedRepository instance = const FeedRepository._();

  @override
  Future<List<FeedModel>> getMany({
    startAfter,
    String searchText = '',
    int size = 20,
    DocumentReference? communityRef,
  }) async {
    var query = FirestoreConfig.feedColRef
        .withConverter<FeedModel>(
          fromFirestore: (snapshot, _) =>
              FeedModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (feed, _) => feed.toJson(),
        )
        .limit(size)
        .where('deletedAt', isNull: true);

    if (communityRef != null) {
      query = query.where('communityRef', isEqualTo: communityRef);
    }

    query = searchText.isEmpty
        ? query.orderBy('createdAt', descending: true)
        : query
            .where('description',
                isGreaterThanOrEqualTo: searchText.toUpperCase())
            .where('description',
                isLessThanOrEqualTo: '${searchText.toUpperCase()}\uf8ff');

    query = startAfter != null ? query.startAfter([startAfter]) : query;

    var snap = startAfter != null
        ? await query.startAfter([startAfter]).get()
        : await query.get();

    if (snap.docs.isEmpty) {
      return [];
    }

    return snap.docs.map((e) => e.data()).toList();
  }

  @override
  Future<FeedModel?> getWithId(String id) async {
    try {
      var doc = FirestoreConfig.feedColRef.doc(id).withConverter<FeedModel>(
            fromFirestore: (snapshot, _) =>
                FeedModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (feed, _) => feed.toJson(),
          );

      var snap = await doc.get();

      if (!snap.exists) null;
      return snap.data();
    } catch (err) {
      return null;
    }
  }

  @override
  Future<FeedModel?> getFromRef(DocumentReference ref) async {
    try {
      var doc = ref.withConverter<FeedModel>(
        fromFirestore: (snapshot, _) =>
            FeedModel.fromJson(snapshot.data() ?? {}),
        toFirestore: (user, _) => user.toJson(),
      );

      var snap = await doc.get();

      if (!snap.exists) null;
      return snap.data();
    } catch (err) {
      return null;
    }
  }

  @override
  Future<FeedModel> edit({
    required CommunityModel community,
    required double amount,
    required String description,
    // Put [ref] to specify the document reference
    FeedType? initialFeedType,
    double? initialAmount,
    DocumentReference? ref,
    bool visibility = false,
    CommunityCurrency currency = CommunityCurrency.usd,

    /// When provided, the feed will be updated instead of created
    String? id,
    FeedType type = FeedType.none,
    List<String>? picture,
    String? placeName,
  }) async {
    assert(
        (ref != null && initialAmount != null && initialFeedType != null) ||
            ref == null,
        'When ref is provided, [initialAmount] and [initialFeedType] should not be null.');

    var currentUser = General.instance.checkAuth();
    var doc = ref ?? FirestoreConfig.feedColRef.doc(id);

    // Check if the feed already exists when creating
    if (id == null) {
      var snap = await doc.get();
      if (snap.exists) {
        throw FeedException(code: FeedExceptionCode.alreadyExists);
      }
    }

    var feed = FeedModel(
      id: doc.id,
      amount: type == FeedType.none ? 0 : amount,
      currency: currency,
      description: description,
      type: type,
      placeName: placeName,
      visibility: visibility,
      picture: picture ?? [],
      writerRef: FirestoreConfig.userColRef.doc(currentUser.uid),
      communityRef: community.ref,
      createdAt: DateTime.now(),
    );

    if (id == null) {
      var batch = FirebaseFirestore.instance.batch();

      if (type == FeedType.income) {
        batch.update(community.ref, {
          'totalIncome': FieldValue.increment(amount),
        });
      } else if (type == FeedType.consume) {
        batch.update(community.ref, {
          'totalConsume': FieldValue.increment(amount),
        });
      }

      batch.set(doc, feed.toJson());
      await batch.commit();
      return feed;
    }

    var batch = FirebaseFirestore.instance.batch();

    if (initialAmount != null) {
      if (initialFeedType == FeedType.income) {
        batch.update(community.ref, {
          'totalIncome': FieldValue.increment(-initialAmount),
        });
      } else if (initialFeedType == FeedType.consume) {
        batch.update(community.ref, {
          'totalConsume': FieldValue.increment(-initialAmount),
        });
      }
    }

    var price = type == FeedType.none ? 0 : amount;

    if (type == FeedType.income) {
      batch.update(community.ref, {
        'totalIncome': FieldValue.increment(price),
      });
    } else if (type == FeedType.consume) {
      batch.update(community.ref, {
        'totalConsume': FieldValue.increment(price),
      });
    }

    batch.update(
      doc,
      {
        'amount': price,
        'currency': currency.name,
        'description': description,
        'type': type.name,
        'placeName': placeName,
        'picture': picture ?? [],
        'writerRef': FirestoreConfig.userColRef.doc(currentUser.uid),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();

    return feed;
  }

  @override
  Future<bool> delete(FeedModel feed) async {
    if (!feed.isWriter) return false;

    var feedDoc = FirestoreConfig.feedColRef.doc(feed.id);
    var batch = FirebaseFirestore.instance.batch();

    if (feed.type == FeedType.income) {
      batch.update(feed.communityRef, {
        'totalIncome': FieldValue.increment(-feed.amount),
      });
    } else if (feed.type == FeedType.consume) {
      batch.update(feed.communityRef, {
        'totalConsume': FieldValue.increment(-feed.amount),
      });
    }

    batch.update(feedDoc, {
      'deletedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    return true;
  }

  @override
  Future<void> like(String id, bool shouldLike) async {
    var currentUser = General.instance.checkAuth();

    var feedUserLikeDoc = await FirestoreConfig.feedColRef
        .doc(id)
        .collection('likes')
        .doc(currentUser.uid)
        .get();

    var batch = FirebaseFirestore.instance.batch();

    if (shouldLike) {
      // 1. Add likes to user
      // 1-1. Remove dislikes from user if exists
      batch.delete(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('dislikes')
            .doc(id),
      );

      batch.set(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('likes')
            .doc(id),
        {
          'feedRef': FirestoreConfig.feedColRef.doc(id),
          'replyRef': null,
          'createdAt': DateTime.now(),
        },
      );

      // 2. Add likes to feed
      // 2-1. Remove dislikes from feed if exists
      if (!feedUserLikeDoc.exists) {
        batch.set(
          FirestoreConfig.feedColRef.doc(id),
          {'likeCount': FieldValue.increment(1)},
          SetOptions(merge: true),
        );

        batch.delete(feedUserLikeDoc.reference);
      }

      batch.set(
        feedUserLikeDoc.reference,
        {
          'userRef': FirestoreConfig.userColRef.doc(currentUser.uid),
          'createdAt': DateTime.now(),
        },
      );

      await batch.commit();
      return;
    }

    // Unlike feed
    // 1. Delete likes from user
    batch.delete(
      FirestoreConfig.userColRef
          .doc(currentUser.uid)
          .collection('likes')
          .doc(id),
    );

    // 2. Delete likes from feed
    if (feedUserLikeDoc.exists) {
      batch.set(
        FirestoreConfig.feedColRef.doc(id),
        {'likeCount': FieldValue.increment(-1)},
        SetOptions(merge: true),
      );
    }

    batch.delete(feedUserLikeDoc.reference);
    await batch.commit();
  }

  @override
  Future<void> dislike(String id, bool shouldDislike) async {
    var currentUser = General.instance.checkAuth();
    var batch = FirebaseFirestore.instance.batch();

    var feedUserLikeDoc = await FirestoreConfig.feedColRef
        .doc(id)
        .collection('likes')
        .doc(currentUser.uid)
        .get();

    var feedUserDislikeDoc = await FirestoreConfig.feedColRef
        .doc(id)
        .collection('dislikes')
        .doc(currentUser.uid)
        .get();

    if (shouldDislike) {
      // 1. Add dislikes to user
      // 1-1. Remove dislikes from user if exists
      batch.delete(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('likes')
            .doc(id),
      );

      batch.set(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('dislikes')
            .doc(id),
        {
          'feedRef': FirestoreConfig.feedColRef.doc(id),
          'replyRef': null,
          'createdAt': DateTime.now(),
        },
      );

      // 1-2. Add dislikes to user
      batch.set(
        FirestoreConfig.userColRef
            .doc(currentUser.uid)
            .collection('dislikes')
            .doc(id),
        {
          'feedRef': FirestoreConfig.feedColRef.doc(id),
          'replyRef': null,
          'createdAt': DateTime.now(),
        },
      );

      // 2. Add dislikes to feed
      // 2-1. Remove likes from feed if exists
      if (feedUserLikeDoc.exists) {
        batch.set(
          FirestoreConfig.feedColRef.doc(id),
          {'likeCount': FieldValue.increment(-1)},
          SetOptions(merge: true),
        );

        batch.delete(feedUserLikeDoc.reference);
        await batch.commit();
      }

      // 2-2. Remove likes from feed if exists
      if (!feedUserDislikeDoc.exists) {
        batch.set(
          FirestoreConfig.feedColRef.doc(id),
          {'dislikeCount': FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      }

      batch.set(
        feedUserDislikeDoc.reference,
        {
          'userRef': FirestoreConfig.userColRef.doc(currentUser.uid),
          'createdAt': DateTime.now(),
        },
      );

      await batch.commit();
      return;
    }

    // Unlike feed
    // 1. Delete dislikes from user
    batch.delete(
      FirestoreConfig.userColRef
          .doc(currentUser.uid)
          .collection('dislikes')
          .doc(id),
    );

    // 2. Delete dislikes from feed
    if (feedUserDislikeDoc.exists) {
      batch.set(
        FirestoreConfig.feedColRef.doc(id),
        {'dislikeCount': FieldValue.increment(-1)},
        SetOptions(merge: true),
      );
    }

    batch.delete(feedUserDislikeDoc.reference);
    await batch.commit();
  }
}
