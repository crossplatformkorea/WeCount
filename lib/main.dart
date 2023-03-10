import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  await dotenv.load(fileName: 'dotenv');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setDefaultLocale(ui.window.locale.languageCode);
  runApp(const MyApp());
}
