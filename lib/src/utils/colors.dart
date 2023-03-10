import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

enum ColorType {
  red,
  orange,
  yellow,
  green,
  blue,
  dusk,
  purple,
}

var communityColors = [
  StaticColors.green,
  StaticColors.blue,
  StaticColors.main,
  StaticColors.purple,
  StaticColors.red,
  StaticColors.orange,
  StaticColors.yellow,
  StaticColors.black,
];

/// https://stackoverflow.com/a/71341102/8841562
Color getFontColorForBackground(Color background) {
  return (background.computeLuminance() > 0.179) ? Colors.black : Colors.white;
}

class StaticColors {
  const StaticColors._();
  static const red = Color.fromRGBO(255, 114, 141, 1);
  static const orange = Color.fromRGBO(245, 166, 35, 1);
  static const yellow = Color.fromRGBO(240, 192, 0, 1);
  static const green = Color.fromRGBO(29, 211, 168, 1);
  static const blue = Color.fromRGBO(103, 157, 255, 1);
  static const main = Color.fromRGBO(13, 178, 147, 1);
  static const purple = Color.fromRGBO(182, 105, 249, 1);
  static const googleBg = Color.fromRGBO(255, 255, 255, 1);
  static const black = Color(0xFF24272d);
}

enum ColorSchemeType { bg, role, text, button }

class _BgColor {
  _BgColor({
    required this.basic,
    required this.paper,
    required this.disabled,
    required this.border,
  });
  final Color basic;
  final Color paper;
  final Color disabled;
  final Color border;

  static _BgColor get lightTheme => _BgColor(
        basic: const Color(0xFFFFFFFF),
        paper: const Color(0xFFF2F5F6),
        disabled: const Color(0xFFC4C4C4),
        border: const Color.fromRGBO(0, 0, 0, 0.2),
      );

  static _BgColor get darkTheme => _BgColor(
        basic: const Color(0xFF000000),
        paper: const Color(0xFF414141),
        disabled: const Color(0xFFC4C4C4),
        border: const Color.fromRGBO(255, 255, 255, 0.2),
      );
}

class _RoleColor {
  _RoleColor({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.brand,
    required this.danger,
    required this.warning,
    required this.info,
    required this.success,
    required this.light,
  });
  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color brand;
  final Color danger;
  final Color warning;
  final Color info;
  final Color success;
  final Color light;

  static _RoleColor get lightTheme => _RoleColor(
        primary: const Color(0xFF0DB293),
        primaryLight: const Color(0xFF75D0B8),
        brand: const Color(0xFF28DB98),
        secondary: const Color(0xFF00D9D5),
        danger: const Color(0xFFF84444),
        warning: const Color(0xFFF2DF0F),
        info: const Color(0xFF3A74E7),
        success: const Color(0xFF4CD964),
        light: const Color(0xFFE5E5EA),
      );

  static _RoleColor get darkTheme => _RoleColor(
        primary: const Color(0xFF75D0B8),
        primaryLight: const Color(0xFF0DB293),
        brand: const Color(0xFF28DB98),
        secondary: const Color(0xFF8E8E93),
        danger: const Color(0xFFFF728D),
        warning: const Color(0xFFFF9500),
        info: const Color(0xFFAFC2DB),
        success: const Color(0xFF4CD964),
        light: const Color(0xFF6D6D6D),
      );
}

class _TextColor {
  _TextColor({
    required this.basic,
    required this.primary,
    required this.placeholder,
    required this.disabled,
    required this.contrast,
    required this.validation,
    required this.secondary,
    required this.link,
    required this.accent,
  });
  final Color basic;
  final Color primary;
  final Color placeholder;
  final Color disabled;
  final Color contrast;
  final Color validation;
  final Color secondary;
  final Color link;
  final Color accent;

  static _TextColor get lightTheme => _TextColor(
        basic: const Color(0xFF222222),
        primary: const Color(0xFF000000),
        placeholder: const Color(0xFFB5B6B9),
        disabled: const Color(0xFFC4C4C4),
        contrast: const Color(0xFFFFFFFF),
        validation: const Color(0xFFFF3B30),
        secondary: const Color(0xFF869AB7),
        link: const Color(0xFF3D3D3D),
        accent: const Color(0xFF5AC8FA),
      );

  static _TextColor get darkTheme => _TextColor(
        basic: const Color(0xFFB3B3B3),
        primary: const Color(0xFFFFFFFF),
        placeholder: const Color(0xFF6D6D6D),
        disabled: const Color(0xFFC4C4C4),
        contrast: const Color(0xFF000000),
        validation: const Color(0xFFFF3B30),
        secondary: const Color(0xFF8E8E93),
        link: const Color(0xFFA0A0A0),
        accent: const Color(0xFF5AC8FA),
      );
}

class _ButtonColorType {
  const _ButtonColorType(this.text, this.bg);
  final Color text;
  final Color bg;
}

class _ButtonColor {
  _ButtonColor({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.light,
  });
  final _ButtonColorType primary;
  final _ButtonColorType secondary;
  final _ButtonColorType success;
  final _ButtonColorType danger;
  final _ButtonColorType warning;
  final _ButtonColorType info;
  final _ButtonColorType light;

  static _ButtonColor get lightTheme => _ButtonColor(
        primary: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFF0DB293),
        ),
        secondary: const _ButtonColorType(
          Color(0xFF000000),
          Color(0xFFE5E5EA),
        ),
        success: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFF4CD964),
        ),
        danger: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFFFF3B30),
        ),
        warning: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFFFF9500),
        ),
        info: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFF5AC8FA),
        ),
        light: const _ButtonColorType(
          Colors.black,
          Color(0xFFC3C3C3),
        ),
      );

  static _ButtonColor get darkTheme => _ButtonColor(
        primary: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFF75D0B8),
        ),
        secondary: const _ButtonColorType(
          Color(0xFF000000),
          Color(0xFF8E8E93),
        ),
        success: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFF4CD964),
        ),
        danger: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFFFF3B30),
        ),
        warning: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFFFF9500),
        ),
        info: const _ButtonColorType(
          Color(0xFFFFFFFF),
          Color(0xFF5AC8FA),
        ),
        light: const _ButtonColorType(
          Colors.white,
          Color(0xFF6D6D6D),
        ),
      );
}

// https://stackoverflow.com/a/56307575/8841562
var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;
bool isLightMode = brightness != Brightness.dark;

class AppColors {
  AppColors._();
  static var bg = isLightMode ? _BgColor.lightTheme : _BgColor.darkTheme;
  static var role = isLightMode ? _RoleColor.lightTheme : _RoleColor.darkTheme;
  static var text = isLightMode ? _TextColor.lightTheme : _TextColor.darkTheme;
  static var button =
      isLightMode ? _ButtonColor.lightTheme : _ButtonColor.darkTheme;
}

const _darkModeStatusBarColor = SystemUiOverlayStyle(
  statusBarColor: Colors.black,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const _lightModeStatusBarColor = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

var statusBarBrightness = brightness == Brightness.dark
    ? _darkModeStatusBarColor
    : _lightModeStatusBarColor;
