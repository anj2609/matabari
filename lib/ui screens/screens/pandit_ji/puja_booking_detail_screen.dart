import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/pandit_bottom_nav.dart';

class PujaBookingDetailScreen extends StatefulWidget {
  final int bookingId;

  const PujaBookingDetailScreen({super.key, required this.bookingId});

  @override
  State<PujaBookingDetailScreen> createState() => _PujaBookingDetailScreenState();
}

class _PujaBookingDetailScreenState extends State<PujaBookingDetailScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _detail;

  /// Default puja inclusions shown until the API provides a real
  /// `puja.inclusions` list (expected as [{"name": ..., "icon": ...}] or
  /// plain strings).
  static const List<Map<String, String>> _defaultInclusions = [
    {"icon": "spa", "title": "Puja Samagri"},
    {"icon": "prasad", "title": "Prasad"},
    {"icon": "aarti", "title": "Aarti"},
    {"icon": "mantra", "title": "Mantra Path"},
    {"icon": "mandir", "title": "Mandir Seva"},
  ];

  static const Map<String, IconData> _inclusionIcons = {
    "spa": Icons.spa_outlined,
    "prasad": Icons.cake_outlined,
    "aarti": Icons.local_fire_department_outlined,
    "mantra": Icons.menu_book_outlined,
    "mandir": Icons.temple_hindu_outlined,
  };

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await ApiClient.getPanditBookingDetails(widget.bookingId);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _detail = body['data'] as Map<String, dynamic>?);
      } else {
        setState(() => _error = body['message'] as String? ?? "Failed to load booking details.");
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Something went wrong. Please check your connection.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
      case "paid":
        return const Color(0xFF2E7D32);
      case "cancelled":
      case "failed":
        return Colors.redAccent;
      default:
        return const Color(0xFFE07A00);
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso);
      const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
      ];
      return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
    } catch (_) {
      return iso;
    }
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  /// Renders a network image, falling back to a plain icon tile if the URL
  /// is missing or fails to load.
  Widget _networkOrFallback(
    String? url, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    final fallback = Container(
      height: height,
      width: width,
      color: const Color(0xFFFFF4E6),
      child: const Icon(Icons.image_not_supported_outlined, color: ColorResources.kOrange),
    );

    if (url == null || url.isEmpty) return fallback;

    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: PanditBottomNav(
        currentIndex: 1,
        onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Group 31.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .2),
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _notify(context, "Sharing puja details"),
                            child: Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .2),
                              ),
                              child: const Icon(Icons.share_outlined, color: Colors.white, size: 15),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: const Alignment(0, -0.5),
                          child: Text(
                            "Puja Details",
                            style: cormorantInfantBold.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.spacingSize22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// BODY
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffF8F5F0),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff9D1911),
                            strokeWidth: 2,
                          ),
                        )
                      : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: avenirNextRegular.copyWith(
                                color: ColorResources.textLight,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        )
                      : _detail == null
                      ? Center(
                          child: Text(
                            "Booking not found",
                            style: avenirNextRegular.copyWith(color: ColorResources.textLight),
                          ),
                        )
                      : _content(context, _detail!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Map<String, dynamic> data) {
    final devotee = data['devotee'] as Map<String, dynamic>? ?? {};
    final puja = data['puja'] as Map<String, dynamic>? ?? {};
    final amount = data['amount'] as Map<String, dynamic>? ?? {};
    final members = (data['members'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final chadawa = (data['chadawa'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final isSelf = data['is_self'] == true;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _pujaCard(data, puja, isSelf, members.length),
          ),
          const SizedBox(height: 20),

          _sectionTitle("Devotee Information"),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _devoteeCard(context, devotee),
          ),
          const SizedBox(height: 20),

          _sectionTitle("Sankalp Details"),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _sankalpCard(data, devotee, isSelf, members.length),
          ),
          const SizedBox(height: 20),

          _sectionTitle(isSelf ? "Booking For" : "Family Members"),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _membersCard(isSelf, members),
          ),
          const SizedBox(height: 20),

          if ((puja['description'] as String? ?? '').isNotEmpty) ...[
            _sectionTitle("About This Puja"),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _pujaDescriptionCard(puja),
            ),
            const SizedBox(height: 20),
          ],

          _sectionTitle("Puja Inclusions"),
          const SizedBox(height: 10),
          _inclusionsRow(puja),
          const SizedBox(height: 20),

          if (chadawa.isNotEmpty) ...[
            _sectionTitle("Chadhava / Offerings"),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _chadawaCard(chadawa),
            ),
            const SizedBox(height: 20),
          ],

          _sectionTitle("Payment Information"),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _paymentCard(data, amount),
          ),
          const SizedBox(height: 20),

          _trustFooter(),
        ],
      ),
    );
  }

  /// ---------------- PUJA CARD ----------------
  Widget _pujaCard(
    Map<String, dynamic> data,
    Map<String, dynamic> puja,
    bool isSelf,
    int memberCount,
  ) {
    final status = data['booking_status'] as String? ?? '';
    final duration = puja['duration'] as String? ?? '';
    final familyLabel = isSelf
        ? "Self"
        : "Family ($memberCount Member${memberCount == 1 ? '' : 's'})";

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: _networkOrFallback(puja['thumbnail'] as String?, height: 150, width: double.infinity),
          ),
          Container(
            height: 150,
            width: double.infinity,
            color: const Color(0x99650E07),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(status),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _capitalize(status),
                style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  puja['name'] as String? ?? '',
                  style: cormorantInfantBold.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(data['booking_date'] as String?),
                      style: avenirNextRegular.copyWith(color: Colors.white, fontSize: 10),
                    ),
                    if (duration.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: avenirNextRegular.copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      familyLabel,
                      style: avenirNextRegular.copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: _gradientText(
        title,
        cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
      ),
    );
  }

  /// ---------------- DEVOTEE INFO ----------------
  Widget _devoteeCard(BuildContext context, Map<String, dynamic> devotee) {
    final name = devotee['name'] as String? ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final image = devotee['image'] as String?;
    final email = devotee['email'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: (image == null || image.isEmpty)
                ? Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: ColorResources.kOrange.withValues(alpha: .16),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffF3D8B3)),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: cormorantInfantBold.copyWith(
                          color: const Color(0xff9D1911),
                          fontSize: Dimensions.fontSizeExtraLarge,
                        ),
                      ),
                    ),
                  )
                : Image.network(
                    image,
                    height: 46,
                    width: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: ColorResources.kOrange.withValues(alpha: .16),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: cormorantInfantBold.copyWith(
                            color: const Color(0xff9D1911),
                            fontSize: Dimensions.fontSizeExtraLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.call_outlined, size: 11, color: Color(0xffF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      devotee['phone'] as String? ?? '',
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.mail_outline, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: avenirNextRegular.copyWith(
                            color: ColorResources.textLight,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _notify(context, "Opening chat with $name"),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: _redGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Message",
                style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- SANKALP DETAILS ----------------
  /// Gotra/Sankalp Name/Special Note aren't in the booking-details response
  /// yet - these fall back to sensible derived defaults until the API adds
  /// "gotra", "sankalp_name" and "special_note" fields.
  Widget _sankalpCard(
    Map<String, dynamic> data,
    Map<String, dynamic> devotee,
    bool isSelf,
    int memberCount,
  ) {
    final devoteeName = devotee['name'] as String? ?? '';
    final familyLabel = isSelf
        ? "Self"
        : "Family ($memberCount Member${memberCount == 1 ? '' : 's'})";

    final rows = {
      "Gotra": data['gotra'] as String? ?? "$devoteeName & Family",
      "Sankalp Name": data['sankalp_name'] as String? ?? devoteeName,
      "Family Members": familyLabel,
      "Special Note": data['special_note'] as String? ??
          "Please pray for good health and prosperity for the family.",
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    e.key,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    e.value,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ---------------- FAMILY MEMBERS ----------------
  Widget _membersCard(bool isSelf, List<Map<String, dynamic>> members) {
    if (members.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Text(
          isSelf ? "This puja was booked for the devotee themself." : "No family members listed.",
          style: avenirNextRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < members.length; i++) ...[
            if (i != 0) Divider(color: const Color(0xffF3D8B3).withValues(alpha: .6), height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(
                    (members[i]['gender'] as String?) == 'female' ? Icons.female : Icons.male,
                    size: 14,
                    color: const Color(0xffF59E0B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      members[i]['name'] as String? ?? '',
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.spacingSize14,
                      ),
                    ),
                  ),
                  Text(
                    _capitalize(members[i]['relation'] as String? ?? ''),
                    style: avenirNextRegular.copyWith(
                      color: const Color(0xff9D1911),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// ---------------- PUJA DESCRIPTION ----------------
  Widget _pujaDescriptionCard(Map<String, dynamic> puja) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Text(
        puja['description'] as String? ?? '',
        style: avenirNextRegular.copyWith(
          color: ColorResources.textLight,
          fontSize: Dimensions.fontSizeDefault,
          height: 1.5,
        ),
      ),
    );
  }

  /// ---------------- PUJA INCLUSIONS ----------------
  /// Uses puja['inclusions'] if the API provides it (list of strings, or
  /// list of {"name"/"title": ...} maps); otherwise falls back to the
  /// default inclusion set below.
  Widget _inclusionsRow(Map<String, dynamic> puja) {
    final raw = puja['inclusions'] as List<dynamic>?;

    final items = (raw == null || raw.isEmpty)
        ? _defaultInclusions
        : raw.map((entry) {
            if (entry is Map) {
              final title = (entry['name'] ?? entry['title'] ?? '').toString();
              final icon = (entry['icon'] ?? '').toString();
              return {"icon": icon, "title": title};
            }
            return {"icon": "", "title": entry.toString()};
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(color: Color(0xFFFFF4E6), shape: BoxShape.circle),
                  child: Icon(
                    _inclusionIcons[item['icon']] ?? Icons.check_circle_outline,
                    color: ColorResources.kOrange,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['title']!,
                  textAlign: TextAlign.center,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: 9,
                  ),
                ),
                Text(
                  "Included",
                  style: avenirNextRegular.copyWith(
                    color: const Color(0xff9D1911),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ---------------- CHADHAVA / OFFERINGS ----------------
  Widget _chadawaCard(List<Map<String, dynamic>> chadawa) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < chadawa.length; i++) ...[
            if (i != 0) Divider(color: const Color(0xffF3D8B3).withValues(alpha: .6), height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${chadawa[i]['name'] ?? ''} × ${chadawa[i]['qty'] ?? ''}",
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.spacingSize14,
                      ),
                    ),
                  ),
                  Text(
                    "₹${chadawa[i]['price'] ?? '0'}",
                    style: avenirNextRegular.copyWith(
                      color: const Color(0xff9D1911),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// ---------------- PAYMENT INFORMATION ----------------
  Widget _paymentCard(Map<String, dynamic> data, Map<String, dynamic> amount) {
    final paymentStatus = data['payment_status'] as String? ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        children: [
          _paymentRow("Base Price", "₹${amount['base_price'] ?? '0'}"),
          const SizedBox(height: 8),
          _paymentRow("Pandit Fee", "₹${amount['pandit_fee'] ?? '0'}"),
          const SizedBox(height: 8),
          _paymentRow("Grand Total", "₹${amount['grand_total'] ?? '0'}"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment Status",
                style: avenirNextRegular.copyWith(
                  color: ColorResources.textLight,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor(paymentStatus),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _capitalize(paymentStatus),
                  style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _paymentRow(
            "Payment Method",
            data['payment_method'] as String? ?? 'Online Payment',
            valueBold: false,
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(String label, String value, {bool valueBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: avenirNextRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
        Text(
          value,
          style: valueBold
              ? cormorantInfantBold.copyWith(
                  color: const Color(0xff9D1911),
                  fontSize: Dimensions.spacingSize16,
                )
              : avenirNextRegular.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }

  /// ---------------- TRUST FOOTER ----------------
  Widget _trustFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xff9D1911), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "All payments are secure and managed by Mata Tripura Sundari "
              "Shaktipeeth e-Darshan",
              style: avenirNextRegular.copyWith(
                color: ColorResources.textLight,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
