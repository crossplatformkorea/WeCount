import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

import '../utils/config.dart';

class PaypalServices {
  String domain = Config().environment == 'production'
      ? 'https://api.paypal.com'
      : 'https://api.sandbox.paypal.com';

  String clientId = Config().paypalClientId;
  String secret = Config().paypalSecret;

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(Uri(
          scheme: 'https',
          host: 'api.sandbox.paypal.com',
          path: '/v1/oauth2/token',
          queryParameters: {'grant_type': 'client_credentials'}));
      if (response.statusCode == 200) {
        var body = convert.jsonDecode(response.body);
        return body['access_token'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(
        Uri(
            scheme: 'https',
            host: 'api.sandbox.paypal.com',
            path: '/v1/payments/payment',
            queryParameters: {'grant_type': 'client_credentials'}),
      );

      var body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body['links'] != null && body['links'].length > 0) {
          List links = body['links'];

          var executeUrl = '';
          var approvalUrl = '';
          var item = links.firstWhere((o) => o['rel'] == 'approval_url',
              orElse: () => null);
          if (item != null) {
            approvalUrl = item['href'];
          }
          var item1 = links.firstWhere((o) => o['rel'] == 'execute',
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1['href'];
          }
          return {'executeUrl': executeUrl, 'approvalUrl': approvalUrl};
        }
        return null;
      } else {
        throw Exception(body['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(
        url,
        body: convert.jsonEncode({'payer_id': payerId}),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      var body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body['id'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
