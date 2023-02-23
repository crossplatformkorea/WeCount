import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

var numFormat = NumberFormat('###,###,###,###');
var dateTimeFormat = DateFormat('yyyy-MM-dd hh:mm a');

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

String sha256ofString(String input) {
  var bytes = utf8.encode(input);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
