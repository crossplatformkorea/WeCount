import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'tools.dart';

class Config {
  factory Config() {
    return _singleton;
  }

  Config._internal();
  static final Config _singleton = Config._internal();

  String get environment => env('GEO_API_KEY');
  String get useEmulator => env('PLACE_API_KEY');
  String get emulatorIpAddress => env('EMULATOR_IP_ADDRESS');
  String get webPushToken => env('WEB_PUSH_TOKEN');
  String get googleWebClientId => env('GOOGLE_WEB_CLIENT_ID');
}

String env(String key) {
  try {
    return dotenv.get(key);
  } on AssertionError catch (e) {
    if (e.message == 'A non-null fallback is required for missing entries') {
      logger.e(
        '$key Key does not exist. '
        "Make sure that the key exists in the 'dotenv' file.",
      );
    }

    rethrow;
  }
}

bool useEmulator() => Config().useEmulator == ''
    ? false
    : Config().useEmulator.toLowerCase() == 'true';
