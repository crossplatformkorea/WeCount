import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/firestore_config.dart';
import '../utils/general.dart';
import '../utils/tools.dart';

abstract class INotificationRepository {
  Future<bool> addToken({required String token});
  Future<bool> removeToken({required String token});
}

class NotificationRepository implements INotificationRepository {
  const NotificationRepository._();
  static NotificationRepository instance = const NotificationRepository._();

  @override
  Future<bool> addToken({required String token}) async {
    try {
      var user = General.instance.checkAuth();
      var doc = await FirestoreConfig.userColRef.doc(user.uid).get();

      if (doc.exists) {
        await FirestoreConfig.userColRef.doc(user.uid).update({
          'notificationTokens': FieldValue.arrayUnion([token])
        });

        return true;
      }

      unawaited(FirebaseAuth.instance.signOut());
      return false;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> removeToken({required String token}) async {
    try {
      var user = General.instance.checkAuth();

      await FirestoreConfig.userColRef.doc(user.uid).update({
        'notificationTokens': FieldValue.arrayRemove([token])
      });

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }
}
