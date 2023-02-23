import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _showFeedsInIntro = FirebaseAuth.instance.currentUser == null;
  final List<String> _bannedUserIds = [];

  bool get showFeedsInIntro => _showFeedsInIntro;
  set showFeedsInIntro(bool value) {
    _showFeedsInIntro = value;
    notifyListeners();
  }

  List<String> get bannedUserIds => _bannedUserIds;

  void addBannedUserId({
    required String userId,
    bool toFirst = true,
  }) {
    if (!_bannedUserIds.contains(userId)) {
      if (toFirst) {
        _bannedUserIds.insert(0, userId);
      } else {
        _bannedUserIds.add(userId);
      }
    }

    notifyListeners();
  }

  void addManyBannedUserIds({
    required List<String> userIds,
    bool toFirst = true,
  }) {
    for (var el in userIds) {
      if (!_bannedUserIds.contains(el)) {
        if (toFirst) {
          _bannedUserIds.insert(0, el);
        } else {
          _bannedUserIds.add(el);
        }
      }
    }

    notifyListeners();
  }

  void clearBannedUserIds() {
    _bannedUserIds.clear();

    notifyListeners();
  }

  void remove(String userId) {
    _bannedUserIds.remove(userId);
    notifyListeners();
  }
}
