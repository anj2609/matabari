import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/pandit_bottom_nav.dart';

class PujaBookingDetailScreen extends StatelessWidget {
  final Map<String, String> booking;

  const PujaBookingDetailScreen({super.key, required this.booking});

  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  static const List<Map<String, String>> _inclusions = [
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

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF2E7D32);
      case "Cancelled":
        return Colors.redAccent;
      default:
        return const Color(0xFFE07A00);
    }
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: _pujaCard(),
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle("Devotee Information"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: _devoteeCard(context),
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle("Sankalp Details"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: _sankalpCard(),
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle("Puja Inclusions"),
                        const SizedBox(height: 10),
                        _inclusionsRow(),
                        const SizedBox(height: 20),

                        _sectionTitle("Payment Information"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: _paymentCard(),
                        ),
                        const SizedBox(height: 20),

                        _trustFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- PUJA CARD ----------------
  Widget _pujaCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.asset(
              booking['image'] ?? 'assets/images/Rectangle 693.png',
              fit: BoxFit.cover,
            ),
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
                color: _statusColor(booking['status'] ?? 'Confirmed'),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                booking['status'] ?? 'Confirmed',
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
                  booking['puja'] ?? '',
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
                      "${booking['date']} • ${booking['time']}",
                      style: avenirNextRegular.copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      booking['family'] ?? '',
                      style: avenirNextRegular.copyWith(color: Colors.white, fontSize: 10),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.language, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      "Language: ${booking['language']}",
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
  Widget _devoteeCard(BuildContext context) {
    final name = booking['name'] ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        children: [
          Container(
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
                      booking['phone'] ?? '',
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_outlined, size: 11, color: Color(0xffF59E0B)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking['location'] ?? '',
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
  Widget _sankalpCard() {
    final rows = {
      "Gotra": "${booking['name']} & Family",
      "Sankalp Name": booking['name'] ?? '',
      "Family Members": booking['family'] ?? '',
      "Special Note": "Please pray for good health and prosperity for the family.",
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

  /// ---------------- PUJA INCLUSIONS ----------------
  Widget _inclusionsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: _inclusions.map((item) {
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(color: Color(0xFFFFF4E6), shape: BoxShape.circle),
                  child: Icon(
                    _inclusionIcons[item['icon']],
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

  /// ---------------- PAYMENT INFORMATION ----------------
  Widget _paymentCard() {
    final paymentStatus = booking['paymentStatus'] ?? 'Paid';

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
          _paymentRow("Total Amount", "₹${booking['amount'] ?? '0'}"),
          const SizedBox(height: 8),
          _paymentRow("Paid Amount", "₹${booking['paidAmount'] ?? '0'}"),
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
                  color: _paymentStatusColor(paymentStatus),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  paymentStatus,
                  style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _paymentRow(
            "Payment Method",
            booking['paymentMethod'] ?? 'Online Payment',
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

  Color _paymentStatusColor(String status) {
    switch (status) {
      case "Paid":
        return const Color(0xFF2E7D32);
      case "Refunded":
      case "Pending":
        return const Color(0xFFE07A00);
      case "Failed":
        return Colors.redAccent;
      default:
        return const Color(0xFF2E7D32);
    }
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
