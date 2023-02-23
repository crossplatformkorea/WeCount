import 'package:flutter/material.dart' show AssetImage;

class Assets {
  const Assets._();

  static const _icPath = 'assets/icons';
  // static const _imgPath = 'assets/images';

  static AssetImage icCoin = const AssetImage('$_icPath/coin.png');
  static AssetImage icPlusCircle = const AssetImage('$_icPath/plus_circle.png');
  static AssetImage icDoorEnter = const AssetImage('$_icPath/door_enter.png');
  static AssetImage icGoogle = const AssetImage('$_icPath/google.png');
  static AssetImage icApple = const AssetImage('$_icPath/apple.png');
}
