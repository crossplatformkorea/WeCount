import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FieldValue;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart' show UserModel;
import '../utils/firestore_config.dart';
import '../utils/general.dart';
import '../utils/tools.dart';

abstract class IUserRepository {
  Future<List<UserModel>> getMany({
    startAfter,
    String searchText,
    int size,
  });

  /// Setup user to firestore if not exists
  Future<void> registerIfNewUser(UserModel user);
  Future<UserModel?> getCurrent();
  Future<UserModel?> getWithUID(String uid);
  Future<UserModel?> getFromRef(DocumentReference ref);

  Future<void> updateProfile({
    String? displayName,
    String? description,
    String? photoUrl,
    String? thumbUrl,
  });
  Future<bool> isFollower(String uid);
  Future<bool> isFollowing(String uid);
  Stream<UserModel?> currentStream();
  Future<void> followUser(UserModel user, bool shouldFollow);
  Future<void> deleteFollowing(String uid);

  Future<List<UserModel>> followers({
    /// When `userId` is provided, it will return followers of the user.
    /// If not, it will return followers of the current user.
    String? userId,
    String? startAfter,
    String searchText,
    int size,
  });

  Future<List<UserModel>> followings({
    /// When `userId` is provided, it will return followers of the user.
    /// If not, it will return followers of the current user.
    String? userId,
    String? startAfter,
    String searchText,
    int size,
  });

  /// Manage banned users
  Future<bool> addToBannedUsers(String userId);
  Future<bool> deleteFromBannedUsers(String userId);
  Future<bool> isBannedByYou(String userId);
  Future<List<String>> bannedUserIds();
}

class UserRepository implements IUserRepository {
  const UserRepository._();
  static const UserRepository instance = UserRepository._();

  @override
  Future<UserModel?> getCurrent() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var snap = await FirestoreConfig.userColRef.doc(user.uid).get();

      if (!snap.exists) return null;
      return UserModel.fromJson(snap.data() ?? {});
    }

    return null;
  }

  @override
  Future<void> registerIfNewUser(UserModel user) async {
    var currentUser = General.instance.checkAuth();
    var userDoc = FirestoreConfig.userColRef.doc(currentUser.uid);

    var doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set(user.toJson());
      unawaited(currentUser.updateDisplayName(user.displayName));
    }
  }

  @override
  Future<void> updateProfile({
    String? displayName,
    String? description,
    String? photoUrl,
    String? thumbUrl,
  }) async {
    var currentUser = General.instance.checkAuth();
    await FirestoreConfig.userColRef.doc(currentUser.uid).update({
      'displayName': displayName,
      'description': description,
      'photoUrl': photoUrl,
      'thumbUrl': thumbUrl,
    });
  }

  @override
  Stream<UserModel?> currentStream() {
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirestoreConfig.userColRef.doc(user.uid).snapshots().map((snap) {
      return snap.exists ? UserModel.fromJson(snap.data() ?? {}) : null;
    });
  }

  @override
  Future<List<UserModel>> getMany({
    startAfter,
    String searchText = '',
    int size = 20,
  }) async {
    var query = FirestoreConfig.userColRef
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toJson(),
        )
        .limit(size)
        .where('deletedAt', isNull: true);

    query = searchText.isEmpty
        ? query.orderBy('copiedAt', descending: true)
        : query
            .where('symbol', isGreaterThanOrEqualTo: searchText.toUpperCase())
            .where('symbol',
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
  Future<UserModel?> getWithUID(String uid) async {
    try {
      var doc = FirestoreConfig.userColRef.doc(uid).withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data() ?? {}),
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
  Future<UserModel?> getFromRef(DocumentReference ref) async {
    try {
      var doc = ref.withConverter<UserModel>(
        fromFirestore: (snapshot, _) =>
            UserModel.fromJson(snapshot.data() ?? {}),
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
  Future<bool> isFollower(String uid) {
    try {
      var currentUser = General.instance.checkAuth();

      return FirestoreConfig.userColRef
          .doc(currentUser.uid)
          .collection('followers')
          .doc(uid)
          .get()
          .then((value) => value.exists);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> isFollowing(String uid) {
    try {
      var currentUser = General.instance.checkAuth();

      return FirestoreConfig.userColRef
          .doc(currentUser.uid)
          .collection('followings')
          .doc(uid)
          .get()
          .then((value) => value.exists);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<void> followUser(UserModel user, bool shouldFollow) async {
    var currentUser = General.instance.checkAuth();
    var userFollowingDoc = FirestoreConfig.userColRef
        .doc(currentUser.uid)
        .collection('followings')
        .doc(user.id);

    var peerUser = FirestoreConfig.userColRef.doc(user.id);

    if (peerUser.id == currentUser.uid) {
      return;
    }

    if (!shouldFollow) {
      await userFollowingDoc.delete();

      if (peerUser.id != currentUser.uid) {
        await peerUser.update({
          'followerCount': FieldValue.increment(-1),
        });

        await peerUser.collection('followers').doc(currentUser.uid).delete();

        return;
      }
    }

    var userJSON = user.toJson();

    /// Remove private data
    userJSON.removeWhere((key, value) =>
        key == 'phoneNumber' || key == 'birthday' || key == 'role');

    await userFollowingDoc.set({
      ...userJSON,
      'ref': FirestoreConfig.userColRef.doc(user.id),
      'copiedAt': DateTime.now(),
    });

    var meDoc = await getCurrent();

    if (meDoc != null) {
      var meJSON = meDoc.toJson();
      meJSON.removeWhere((key, value) =>
          key == 'phoneNumber' || key == 'birthday' || key == 'role');

      await peerUser.collection('followers').doc(meDoc.id).set({
        ...meJSON,
        'ref': FirestoreConfig.userColRef.doc(meDoc.id),
        'copiedAt': DateTime.now(),
      });

      await peerUser.update({
        'followerCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Future<List<UserModel>> followers({
    String? userId,
    String? startAfter,
    String searchText = '',
    int size = 20,
  }) async {
    var currentUser = General.instance.checkAuth();

    var userColRef = FirestoreConfig.userColRef
        .doc(userId ?? currentUser.uid)
        .collection('followers')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toJson(),
        );

    var followings = await getPaginatingQuery(
        collectionRef: userColRef, orderBy: 'copiedAt');

    return followings;
  }

  @override
  Future<List<UserModel>> followings({
    String? userId,
    String? startAfter,
    String searchText = '',
    int size = 20,
  }) async {
    var currentUser = General.instance.checkAuth();

    var userColRef = FirestoreConfig.userColRef
        .doc(userId ?? currentUser.uid)
        .collection('followings')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toJson(),
        );

    var followings = await getPaginatingQuery(
        collectionRef: userColRef, orderBy: 'copiedAt');
    return followings;
  }

  @override
  Future<void> deleteFollowing(String userId) {
    var currentUser = General.instance.checkAuth();

    return FirestoreConfig.userColRef
        .doc(currentUser.uid)
        .collection('followings')
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> addToBannedUsers(String userId) async {
    var user = General.instance.checkAuth();

    try {
      await FirestoreConfig.userColRef
          .doc(user.uid)
          .collection('banned')
          .doc(userId)
          .set({
        'userRef': FirestoreConfig.userColRef.doc(userId),
        'createdAt': DateTime.now(),
      });

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> deleteFromBannedUsers(String userId) async {
    var user = General.instance.checkAuth();

    try {
      await FirestoreConfig.userColRef
          .doc(user.uid)
          .collection('banned')
          .doc(userId)
          .delete();

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> isBannedByYou(String userId) async {
    var user = General.instance.checkAuth();

    try {
      var cvo = await FirestoreConfig.userColRef
          .doc(user.uid)
          .collection('banned')
          .doc(userId)
          .get();

      return cvo.exists;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<List<String>> bannedUserIds() async {
    try {
      var user = General.instance.checkAuth();

      var bannedList = await FirestoreConfig.userColRef
          .doc(user.uid)
          .collection('banned')
          .get();

      return bannedList.docs.map((e) => e.id).toList();
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}
