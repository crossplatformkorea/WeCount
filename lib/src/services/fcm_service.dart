import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../repositories/notification_repository.dart';
import '../utils/config.dart';
import '../utils/tools.dart';

class FcmService {
  FcmService._();
  static FcmService instance = FcmService._();

  String? token;

  Future<void> requestFirebaseMessaging() async {
    var messaging = FirebaseMessaging.instance;

    var settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      try {
        token = kIsWeb
            ? await messaging.getToken(
                vapidKey: Config().webPushToken,
              )
            : await messaging.getToken();

        if (token != null) {
          await NotificationRepository.instance.addToken(token: token!);
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }
}
