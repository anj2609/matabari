import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matabari/config/utils/apis/api_constants.dart';
import 'package:matabari/config/utils/session_prefs.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 30);

  static Future<Map<String, String>> _authHeaders() async {
    final token = await SessionPrefs.getToken();
    return {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static void _addField(Map<String, String> fields, String key, String? value) {
    if (value != null && value.isNotEmpty) fields[key] = value;
  }

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

  /// Saves the logged-in user's basic profile - shared across all 3 roles,
  /// with only the fields relevant to that role's registration form filled in.
  static Future<http.Response> updateBasicInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? gender,
    String? dob,
    String? skill,
    String? shopName,
    File? profileImage,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.basicInfo}');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _authHeaders());

    _addField(request.fields, 'first_name', firstName);
    _addField(request.fields, 'last_name', lastName);
    _addField(request.fields, 'email', email);
    _addField(request.fields, 'mobile', mobile);
    _addField(request.fields, 'gender', gender);
    _addField(request.fields, 'dob', dob);
    _addField(request.fields, 'skill', skill);
    _addField(request.fields, 'shopname', shopName);

    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profileimage', profileImage.path),
      );
    }

    final streamedResponse = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('basicInfo response [${response.statusCode}]: ${response.body}');

    return response;
  }

  /// Saves a Prasad Seller's shop/business details and required documents.
  static Future<http.Response> submitSellerBusinessDetails({
    int? businessId,
    String? gstNo,
    required String panNo,
    required String registrationNo,
    required String shopAddressLine1,
    String? shopAddressLine2,
    required String state,
    required String pincode,
    required File shopLicenseFile,
    required File fssaiCertificateFile,
    File? gstFile,
    required File adharFile,
    required File panFile,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.sellerBusinessDetails}',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _authHeaders());

    _addField(request.fields, 'business_id', businessId?.toString());
    _addField(request.fields, 'gst_no', gstNo);
    _addField(request.fields, 'pan_no', panNo);
    _addField(request.fields, 'registration_no', registrationNo);
    _addField(request.fields, 'shop_address_line_one', shopAddressLine1);
    _addField(request.fields, 'shop_address_line_two', shopAddressLine2);
    _addField(request.fields, 'state', state);
    _addField(request.fields, 'pincode', pincode);

    request.files.add(
      await http.MultipartFile.fromPath('shop_license_file', shopLicenseFile.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'fssai_certificate_file',
        fssaiCertificateFile.path,
      ),
    );
    if (gstFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('gst_file', gstFile.path),
      );
    }
    request.files.add(
      await http.MultipartFile.fromPath('adhar_file', adharFile.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath('pan_file', panFile.path),
    );

    final streamedResponse = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint(
      'sellerBusinessDetails response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Saves the Prasad Seller's bank/payment details.
  static Future<http.Response> submitBankInfo({
    required String holderName,
    required String bankName,
    required String ifscCode,
    required String acNo,
    required String upiId,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankInfo}');
    final headers = await _authHeaders();
    final response = await http
        .post(
          uri,
          headers: headers,
          body: {
            'holder_name': holderName,
            'bank_name': bankName,
            'ifsc_code': ifscCode,
            'ac_no': acNo,
            'upi_id': upiId,
          },
        )
        .timeout(_timeout);

    debugPrint('bankInfo response [${response.statusCode}]: ${response.body}');

    return response;
  }

  /// Fetches the devotee testimonials shown on the home dashboard.
  static Future<http.Response> getTestimonials() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.testimonialListing}',
    );
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint(
      'testimonialListing response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Fetches contact/about/social details shown on the Help & Support screen.
  static Future<http.Response> getHelpSupport() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.getHelpSupport}',
    );
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint(
      'getHelpSupport response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Fetches a CMS content page (terms, privacy policy, about us, return &
  /// refund policy, etc). [endpoint] is one of the ApiConstants.cms* values.
  static Future<http.Response> getCmsPage(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint('cms[$endpoint] response [${response.statusCode}]: ${response.body}');

    return response;
  }

  /// Fetches the list of existing business types for the "Business Type"
  /// dropdown on the Prasad Seller business details screen.
  static Future<http.Response> getBusinessListing() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.businessListing}',
    );
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint(
      'businessListing response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Fetches a page of the pandit's bookings filtered by [status]
  /// ("upcoming", "today", "completed" or "cancelled").
  static Future<http.Response> getPanditBookings(String status, {int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.panditBookings}',
    ).replace(queryParameters: {'status': status, 'page': page.toString()});
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint(
      'panditBookings[$status?page=$page] response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Fetches full details for a single pandit booking by its numeric id.
  static Future<http.Response> getPanditBookingDetails(int bookingId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.panditBookingDetails}/$bookingId',
    );
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint(
      'panditBookingDetails[$bookingId] response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Fetches the pandit's current wallet balance.
  static Future<http.Response> getPanditWallet() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.panditWallet}');
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint('panditWallet response [${response.statusCode}]: ${response.body}');

    return response;
  }

  /// Fetches a page of the pandit's wallet transaction history.
  static Future<http.Response> getPanditWalletHistory({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.panditWalletHistory}',
    ).replace(queryParameters: {'page': page.toString()});
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint(
      'panditWalletHistory[page=$page] response [${response.statusCode}]: ${response.body}',
    );

    return response;
  }

  /// Fetches the logged-in pandit's profile.
  static Future<http.Response> getPanditProfile() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.panditProfile}');
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint('panditProfile response [${response.statusCode}]: ${response.body}');

    return response;
  }

  /// Fetches the logged-in user's saved bank details.
  static Future<http.Response> getBankInfo() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bankInfo}');
    final response = await http
        .get(uri, headers: await _authHeaders())
        .timeout(_timeout);

    debugPrint('getBankInfo response [${response.statusCode}]: ${response.body}');

    return response;
  }
}
