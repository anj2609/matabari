import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matabari/config/utils/apis/api_constants.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 30);

  static Future<http.Response> sendOtp(String phone) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sendOtp}');
    final response = await http
        .post(uri, headers: {'Accept': 'application/json'}, body: {'phone': phone})
        .timeout(_timeout);

    debugPrint('sendOtp response [${response.statusCode}]: ${response.body}');

    return response;
  }

  static Future<http.Response> verifyOtp(String phone, String otp) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyOtp}');
    final response = await http
        .post(
          uri,
          headers: {'Accept': 'application/json'},
          body: {'phone': phone, 'otp': otp},
        )
        .timeout(_timeout);

    debugPrint('verifyOtp response [${response.statusCode}]: ${response.body}');

    return response;
  }

  static Future<http.Response> resendOtp(String phone) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resendOtp}');
    final response = await http
        .post(uri, headers: {'Accept': 'application/json'}, body: {'phone': phone})
        .timeout(_timeout);

    debugPrint('resendOtp response [${response.statusCode}]: ${response.body}');

    return response;
  }
}
