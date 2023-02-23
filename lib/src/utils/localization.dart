import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n.dart';

S localization(BuildContext context) => S.of(context);

String t(String messageText) => Intl.message(messageText).toString();
