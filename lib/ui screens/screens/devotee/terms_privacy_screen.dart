import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/apis/api_constants.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  static const List<Map<String, String>> _policies = [
    {
      "icon": "description",
      "title": "Terms of Use",
      "subtitle": "Rules and conditions for using our app",
      "body": "By using Matabari, you agree to book pujas, order prasad and "
          "access darshan services responsibly and in good faith. Bookings "
          "are subject to temple availability, and any misuse of the "
          "platform may result in suspension of your account.",
      "endpoint": ApiConstants.cmsTermsAndConditions,
    },
    {
      "icon": "lock",
      "title": "Privacy Policy",
      "subtitle": "How we collect and use your personal data",
      "body": "We collect only the information needed to process your "
          "bookings and offerings - name, contact details and payment "
          "information. Your data is never sold and is used solely to "
          "deliver our puja, aarti and prasad services.",
      "endpoint": ApiConstants.cmsPrivacyPolicy,
    },
    {
      "icon": "refund",
      "title": "Return & Refund Policy",
      "subtitle": "Understand our refund & return process",
      "body": "Refunds are applicable only when a booking or order cannot "
          "be fulfilled by the temple administration. Eligible refunds are "
          "processed within 7-10 business days.",
      "endpoint": ApiConstants.cmsReturnRefundPolicy,
    },
  ];

  static const List<Map<String, String>> _about = [
    {
      "icon": "info",
      "title": "About Maa Tripura Sundari App",
      "subtitle": "Learn more about this app & its mission",
      "body": "Matabari connects devotees with Mata Tripura Sundari "
          "Shaktipeeth, offering puja bookings, live e-Darshan, aarti and "
          "prasad delivery so you can stay connected to the temple from "
          "anywhere.",
      "endpoint": ApiConstants.cmsAboutUs,
    },
  ];

  static const Map<String, IconData> _icons = {
    "description": Icons.description_outlined,
    "lock": Icons.lock_outline,
    "info": Icons.info_outline,
    "refund": Icons.currency_exchange,
  };

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  /// Shows a policy/about item in a bottom sheet. If the item has an
  /// "endpoint" (the 4 CMS-backed items), it fetches the live content from
  /// the backend and renders its HTML, falling back to the static "body"
  /// text on failure. Items without an endpoint just show their static body.
  void _showPolicy(BuildContext context, Map<String, String> item) {
    final endpoint = item['endpoint'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffF8F5F0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
            ),
            child: endpoint == null
                ? _policySheetBody(
                    sheetContext: sheetContext,
                    icon: item['icon'],
                    title: item['title']!,
                    body: Text(
                      item['body']!,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeDefault,
                        height: 1.5,
                      ),
                    ),
                  )
                : FutureBuilder<http.Response>(
                    future: ApiClient.getCmsPage(endpoint),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return _policySheetBody(
                          sheetContext: sheetContext,
                          icon: item['icon'],
                          title: item['title']!,
                          body: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff9D1911),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      }

                      String title = item['title']!;
                      String? htmlBody;
                      try {
                        final response = snapshot.data;
                        if (response != null && response.statusCode == 200) {
                          final data =
                              (jsonDecode(response.body) as Map<String, dynamic>)['data']
                                  as Map<String, dynamic>?;
                          title = data?['name'] as String? ?? title;
                          htmlBody = data?['details'] as String?;
                        }
                      } catch (_) {}

                      return _policySheetBody(
                        sheetContext: sheetContext,
                        icon: item['icon'],
                        title: title,
                        body: SingleChildScrollView(
                          child: htmlBody != null
                              ? Html(data: htmlBody)
                              : Text(
                                  item['body']!,
                                  style: avenirNextRegular.copyWith(
                                    color: ColorResources.textLight,
                                    fontSize: Dimensions.fontSizeDefault,
                                    height: 1.5,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _policySheetBody({
    required BuildContext sheetContext,
    required String? icon,
    required String title,
    required Widget body,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_icons[icon], color: const Color(0xff9D1911), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: Dimensions.spacingSize18,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(sheetContext),
              child: const Icon(Icons.close, color: ColorResources.textLight, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Flexible(child: body),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 18),

              _sectionTitle("Policies"),
              const SizedBox(height: 10),
              ..._policies.map((item) => _policyRow(context, item)),
              const SizedBox(height: 20),

              _sectionTitle("About"),
              const SizedBox(height: 10),
              ..._about.map((item) => _policyRow(context, item)),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _privacyCard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff9D1911)),
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xff9D1911), size: 16),
                ),
              ),
              Expanded(
                child: _gradientText(
                  "Terms & Privacy",
                  cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize22),
                ),
              ),
              GestureDetector(
                onTap: () => _notify(context, "Sharing Terms & Privacy"),
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff9D1911)),
                  ),
                  child: const Icon(Icons.share_outlined, color: Color(0xff9D1911), size: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Read our policies and terms to understand how we\n"
            "protect your data and provide our services",
            textAlign: TextAlign.center,
            style: avenirNextRegular.copyWith(
              color: ColorResources.textLight,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _gradientText(
        title,
        cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
      ),
    );
  }

  /// ---------------- POLICY ROW ----------------
  Widget _policyRow(BuildContext context, Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showPolicy(context, item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xffF3D8B3)),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(color: Color(0xFFFFF4E6), shape: BoxShape.circle),
                child: Icon(_icons[item['icon']], color: ColorResources.kOrange, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle']!,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ColorResources.textLight, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- PRIVACY CARD ----------------
  Widget _privacyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(color: Color(0xFFFFF4E6), shape: BoxShape.circle),
            child: const Icon(Icons.verified_user_outlined, color: ColorResources.kOrange, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We respect your privacy",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
                Text(
                  "Your data is secure. We never share your personal "
                  "information with third parties.",
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _notify(context, "Connecting you to our support team..."),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: _redGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                "Contact us",
                style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
