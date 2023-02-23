import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

var _dynamicLinks = FirebaseDynamicLinks.instance;

class DynamicLinkService {
  DynamicLinkService._();
  static DynamicLinkService instance = DynamicLinkService._();

  Future<String> create({
    required String link,
    SocialMetaTagParameters? socialMetaTagParameters,
    bool short = false,
  }) async {
    var uriPrefix = 'https://wecount.space/link';
    var parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://wecount.space/$link'),
      androidParameters: const AndroidParameters(
        packageName: 'space.wecount',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'space.wecount',
        minimumVersion: '0',
        appStoreId: '1628728777',
        customScheme: 'wecount',
      ),
      socialMetaTagParameters: socialMetaTagParameters,
    );

    Uri url;
    if (short) {
      var shortLink = await _dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await _dynamicLinks.buildLink(parameters);
    }

    return url.toString();
  }
}
