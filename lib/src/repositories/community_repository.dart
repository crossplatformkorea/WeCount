import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FieldValue;
import 'package:flutter/material.dart';
import '../models/community_model.dart';
import '../models/user_model.dart' show UserModel;
import '../utils/exceptions.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';
import '../utils/storage.dart';
import 'user_repository.dart';

abstract class ICommunityRepository {
  Future<List<CommunityModel>> getMany({
    startAfter,
    String searchText,
    int size,
  });

  Future<CommunityModel?> getWithId(String? id);
  Future<CommunityModel?> getFromRef(DocumentReference ref);

  Future<void> updateImages({
    required CommunityModel community,
    required ImageUrlSets images,
  });

  Future<void> edit({
    required String title,
    required Color color,

    /// When provided, the community will be updated instead of created
    String? id,
    bool visibility,
    CommunityCurrency currency,
    String? description,
  });

  Future<bool> hasStarred(String id);
  Future<bool> delete(CommunityModel community);

  Future<void> star({
    required CommunityModel community,
    required bool shouldStar,
  });

  Future<List<UserModel>> starredUsers({
    required String communityId,
    startAfter,
    String searchText = '',
    int size = 20,
  });
}

class CommunityRepository implements ICommunityRepository {
  const CommunityRepository._();
  static CommunityRepository instance = const CommunityRepository._();

  @override
  Future<List<CommunityModel>> getMany({
    startAfter,
    String searchText = '',
    int size = 20,
  }) async {
    var query = FirestoreConfig.communityColRef
        .withConverter<CommunityModel>(
          fromFirestore: (snapshot, _) =>
              CommunityModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (community, _) => community.toJson(),
        )
        .limit(size)
        .where('deletedAt', isNull: true);

    query = searchText.isEmpty
        ? query.orderBy('createdAt', descending: true)
        : query
            .where('title', isGreaterThanOrEqualTo: searchText.toUpperCase())
            .where('title',
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
  Future<CommunityModel?> getWithId(String? id) async {
    if (id == null) return null;

    try {
      var doc =
          FirestoreConfig.communityColRef.doc(id).withConverter<CommunityModel>(
                fromFirestore: (snapshot, _) =>
                    CommunityModel.fromJson(snapshot.data() ?? {}),
                toFirestore: (community, _) => community.toJson(),
              );

      var snap = await doc.get();

      if (!snap.exists) null;
      return snap.data();
    } catch (err) {
      return null;
    }
  }

  @override
  Future<CommunityModel?> getFromRef(DocumentReference ref) async {
    try {
      var doc = ref.withConverter<CommunityModel>(
        fromFirestore: (snapshot, _) =>
            CommunityModel.fromJson(snapshot.data() ?? {}),
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
  Future<void> updateImages({
    required CommunityModel community,
    required ImageUrlSets images,
  }) {
    var doc = FirestoreConfig.communityColRef.doc(community.id);

    return doc.update({
      'photoUrl': images.photoUrl,
      'thumbUrl': images.thumbUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> edit({
    required String title,
    required Color color,
    String? id,
    bool visibility = true,
    CommunityCurrency currency = CommunityCurrency.usd,
    String? description,
  }) async {
    var currentUser = General.instance.checkAuth();
    var doc = FirestoreConfig.communityColRef.doc(id);

    // Check if the community already exists when creating
    if (id == null) {
      var snap = await doc.get();
      if (snap.exists) {
        throw CommunityException(code: CommunityExceptionCode.alreadyExists);
      }
    }

    var community = CommunityModel(
      id: doc.id,
      title: title,
      color: color,
      visibility: visibility,
      currency: currency,
      description: description,
      ownerRef: FirestoreConfig.userColRef.doc(currentUser.uid),
      createdAt: DateTime.now(),
    );

    if (id == null) {
      return await doc.set(community.toJson());
    }

    return await doc.update({
      'title': title,
      'description': description,
      'color': color.value,
      'visibility': visibility,
      'currency': currency.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<bool> hasStarred(String id) {
    try {
      var currentUser = General.instance.checkAuth();

      return FirestoreConfig.communityColRef
          .doc(currentUser.uid)
          .collection('starred')
          .doc(currentUser.uid)
          .get()
          .then((value) => value.exists);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> delete(CommunityModel community) async {
    if (!community.isOwner) return false;

    var communityDoc = FirestoreConfig.communityColRef.doc(community.id);

    await communityDoc.update({'deletedAt': FieldValue.serverTimestamp()});

    return true;
  }

  @override
  Future<void> star({
    required CommunityModel community,
    required bool shouldStar,
  }) async {
    var currentUser = General.instance.checkAuth();
    var userStarredDoc = FirestoreConfig.userColRef
        .doc(currentUser.uid)
        .collection('starredCommunities')
        .doc(community.id);

    var communityDoc = FirestoreConfig.communityColRef.doc(community.id);

    if (communityDoc.id == currentUser.uid) {
      return;
    }

    if (!shouldStar) {
      await userStarredDoc.delete();

      if (communityDoc.id != currentUser.uid) {
        await communityDoc.update({
          'starCount': FieldValue.increment(-1),
        });

        await communityDoc.collection('starred').doc(currentUser.uid).delete();

        return;
      }
    }

    var communityJSON = community.toJson();

    await userStarredDoc.set({
      ...communityJSON,
      'ref': FirestoreConfig.userColRef.doc(community.id),
      'copiedAt': DateTime.now(),
    });

    var meDoc = await UserRepository.instance.getCurrent();

    if (meDoc != null) {
      var meJSON = meDoc.toJson();
      meJSON.removeWhere((key, value) =>
          key == 'phoneNumber' || key == 'birthday' || key == 'role');

      await communityDoc.collection('starred').doc(meDoc.id).set({
        ...meJSON,
        'ref': FirestoreConfig.userColRef.doc(meDoc.id),
        'copiedAt': DateTime.now(),
      });

      await communityDoc.update({
        'starCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Future<List<UserModel>> starredUsers({
    required String communityId,
    startAfter,
    String searchText = '',
    int size = 20,
  }) async {
    var userColRef = FirestoreConfig.communityColRef
        .doc(communityId)
        .collection('starred')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toJson(),
        );

    var users = await getPaginatingQuery(
        collectionRef: userColRef, orderBy: 'copiedAt');

    return users;
  }
}
