import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  final Set<int> expandedFaqs = {};

  Map<String, dynamic>? _helpSupport;

  @override
  void initState() {
    super.initState();
    _fetchHelpSupport();
  }

  Future<void> _fetchHelpSupport() async {
    try {
      final response = await ApiClient.getHelpSupport();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _helpSupport = body['data'] as Map<String, dynamic>?);
      }
    } catch (_) {
      // Non-critical - the screen falls back to its static contact details.
    }
  }

  static const List<Map<String, dynamic>> _quickHelp = [
    {
      "icon": Icons.event_note_outlined,
      "title": "Puja & Booking",
      "subtitle": "Help with Puja,\nAarti & Bookings",
    },
    {
      "icon": Icons.payment_outlined,
      "title": "Payment Issue",
      "subtitle": "Payment failure,\nrefund & more",
    },
    {
      "icon": Icons.person_outline,
      "title": "Account Help",
      "subtitle": "Profile, Password\n& Account related",
    },
  ];

  static const List<Map<String, String>> _faqs = [
    {
      "q": "How can I book a Puja?",
      "a": "Browse the Puja tab, select a puja, choose the type, date and "
          "time slot, then complete payment to confirm your booking.",
    },
    {
      "q": "How can I watch digital darshan?",
      "a": "Open Menu > e-Darshan to watch the temple's live darshan anytime.",
    },
    {
      "q": "What payment methods are accepted?",
      "a": "We accept UPI, Paytm, credit/debit cards and net banking.",
    },
    {
      "q": "How can I cancel or reschedule a booking?",
      "a": "Go to My Puja Bookings, open the booking and tap Reschedule, "
          "or contact our support team to cancel it.",
    },
    {
      "q": "How do I add family members?",
      "a": "Go to Menu > Family Member and tap Add More to add a new "
          "family member to your account.",
    },
  ];

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _launchUri(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) _notify("Couldn't open this link");
  }

  Future<void> _callPhone(String phone) => _launchUri(Uri(scheme: 'tel', path: phone));

  Future<void> _sendEmail(String email) => _launchUri(Uri(scheme: 'mailto', path: email));

  Future<void> _openWebsite(String url) {
    final normalized = url.startsWith('http') ? url : 'https://$url';
    return _launchUri(Uri.parse(normalized));
  }

  Future<void> _openWhatsapp(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return _launchUri(Uri.parse('https://wa.me/$digits'));
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
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
              _header(),
              const SizedBox(height: 18),

              _sectionTitle("Quick Help"),
              const SizedBox(height: 10),
              _quickHelpRow(),
              const SizedBox(height: 22),

              _sectionHeader("Frequently Asked Questions"),
              const SizedBox(height: 10),
              ...List.generate(_faqs.length, _faqTile),
              const SizedBox(height: 22),

              if (_helpSupport?['about'] != null &&
                  (_helpSupport!['about'] as String).isNotEmpty) ...[
                _sectionTitle("About Us"),
                const SizedBox(height: 10),
                _aboutCard(),
                const SizedBox(height: 22),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _stillNeedHelpCard(),
              ),
              const SizedBox(height: 18),

              _contactRow(),

              if (_socialLinks().isNotEmpty) ...[
                const SizedBox(height: 18),
                _sectionTitle("Follow Us"),
                const SizedBox(height: 10),
                _socialRow(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header() {
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
                  "Help & Support",
                  cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize22),
                ),
              ),
              GestureDetector(
                onTap: () => _notify("Sharing Help & Support"),
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
            "We are here to help you",
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _gradientText(
            title,
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
          ),
          const Spacer(),
          Text(
            "View All",
            style: avenirNextCyr.copyWith(
              color: ColorResources.kOrange,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- QUICK HELP ----------------
  Widget _quickHelpRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _quickHelp.map((item) {
          return Expanded(
            child: GestureDetector(
              onTap: () => _notify("Opening ${item['title']} help"),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffF3D8B3)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF4E6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData, color: ColorResources.kOrange, size: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'] as String,
                      textAlign: TextAlign.center,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ---------------- FAQ ----------------
  Widget _faqTile(int index) {
    final faq = _faqs[index];
    final expanded = expandedFaqs.contains(index);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() {
                if (expanded) {
                  expandedFaqs.remove(index);
                } else {
                  expandedFaqs.add(index);
                }
              }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        faq['q']!,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.spacingSize14,
                        ),
                      ),
                    ),
                    Icon(
                      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xff9D1911),
                    ),
                  ],
                ),
              ),
            ),
            if (expanded)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  faq['a']!,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ---------------- STILL NEED HELP ----------------
  Widget _stillNeedHelpCard() {
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
            child: const Icon(Icons.headset_mic_outlined, color: ColorResources.kOrange, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Still need help?",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
                Text(
                  "Our support team is available to assist you.",
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
            onTap: () => _notify("Connecting you to our support team..."),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: _redGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    "Chat with us",
                    style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- ABOUT ----------------
  Widget _aboutCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Text(
          _helpSupport!['about'] as String,
          style: avenirNextRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.fontSizeDefault,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  /// ---------------- SOCIAL LINKS ----------------
  List<(String label, String value, Widget icon)> _socialLinks() {
    final data = _helpSupport;
    if (data == null) return [];

    String? link(String key) {
      final value = data[key] as String?;
      return (value == null || value.isEmpty) ? null : value;
    }

    return [
      if (link('facebook') case final url?)
        ('facebook', url, const Icon(Icons.facebook, color: Colors.white, size: 18)),
      if (link('instagram') case final url?)
        ('instagram', url, const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18)),
      if (link('youtube') case final url?)
        (
          'youtube',
          url,
          Image.asset(
            'assets/images/Youtube.png',
            height: 18,
            width: 18,
            color: Colors.white,
          ),
        ),
      if (link('twitter') case final url?)
        ('twitter', url, const Icon(Icons.alternate_email, color: Colors.white, size: 18)),
      if (link('linkedin') case final url?)
        ('linkedin', url, const Icon(Icons.business_center_outlined, color: Colors.white, size: 18)),
      if (link('whatsapp') case final url?)
        ('whatsapp', url, const Icon(Icons.chat_bubble, color: Colors.white, size: 18)),
    ];
  }

  Widget _socialRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _socialLinks().map((entry) {
          final (label, value, icon) = entry;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => label == 'whatsapp' ? _openWhatsapp(value) : _launchUri(Uri.parse(value)),
              child: Container(
                height: 38,
                width: 38,
                decoration: const BoxDecoration(
                  gradient: _redGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(child: icon),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ---------------- CONTACT ROW ----------------
  Widget _contactRow() {
    final contacts = [
      (Icons.call_outlined, "Phone", _helpSupport?['phone'] as String? ?? "+91 987-654-3210"),
      (Icons.language, "Website", _helpSupport?['website_url'] as String? ?? "www.matabari.org"),
      (Icons.mail_outline, "Email", _helpSupport?['email'] as String? ?? "info@matabari.org"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: contacts.map((c) {
          return Expanded(
            child: GestureDetector(
              onTap: () => switch (c.$2) {
                "Phone" => _callPhone(c.$3),
                "Website" => _openWebsite(c.$3),
                _ => _sendEmail(c.$3),
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffF3D8B3)),
                ),
                child: Column(
                  children: [
                    Icon(c.$1, color: ColorResources.kOrange, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      c.$2,
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    Text(
                      c.$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
