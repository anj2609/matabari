import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class MyPujaBookingsScreen extends StatefulWidget {
  const MyPujaBookingsScreen({super.key});

  @override
  State<MyPujaBookingsScreen> createState() => _MyPujaBookingsScreenState();
}

class _MyPujaBookingsScreenState extends State<MyPujaBookingsScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int selectedTab = 0;

  final List<Map<String, String>> upcomingBookings = const [
    {
      "title": "Maa Tripura Sundari Puja",
      "temple": "Mata Tripura Sundari Temple",
      "date": "25 Jun 2026",
      "time": "09:30 AM",
      "family": "Family (2 Members)",
      "image": "assets/images/Rectangle 693.png",
    },
    {
      "title": "Navgraha Shanti Puja",
      "temple": "Mata Tripura Sundari Temple",
      "date": "02 Jul 2026",
      "time": "10:00 AM",
      "family": "Family (3 Members)",
      "image": "assets/images/Rectangle 720.png",
    },
    {
      "title": "Kumari Puja",
      "temple": "Mata Tripura Sundari Temple",
      "date": "13 Jul 2026",
      "time": "09:00 AM",
      "family": "Family (2 Members)",
      "image": "assets/images/Rectangle 708.png",
    },
  ];

  final List<Map<String, String>> completedBookings = const [
    {
      "title": "Durga Saptashati Path",
      "temple": "Mata Tripura Sundari Temple",
      "date": "15 May 2026",
      "time": "08:00 AM",
      "family": "Family (2 Members)",
      "image": "assets/images/Rectangle 725.png",
    },
  ];

  final List<Map<String, String>> cancelledBookings = const [];

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeList = switch (selectedTab) {
      1 => completedBookings,
      2 => cancelledBookings,
      _ => upcomingBookings,
    };

    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
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
                          _circleIconButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.maybePop(context),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "My Puja Bookings",
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.spacingSize22,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Track upcoming & completed puja",
                                  style: avenirNextRegular.copyWith(
                                    color: Colors.white70,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _circleIconButton(
                            icon: Icons.ios_share,
                            onTap: () => _notify("Sharing your booking history"),
                          ),
                        ],
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
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xffF3D8B3)),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: List.generate(3, (index) => _tabButton(index)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (selectedTab == 0) ...[
                                _sectionHeader("Upcoming Pujas", upcomingBookings.length),
                                const SizedBox(height: 10),
                                ...upcomingBookings.map((b) => _bookingCard(b, upcoming: true)),
                              ] else if (selectedTab == 1) ...[
                                _sectionHeader("Completed Pujas", completedBookings.length),
                                const SizedBox(height: 10),
                                ...completedBookings.map((b) => _bookingCard(b, upcoming: false)),
                              ] else ...[
                                _sectionHeader("Cancelled Pujas", cancelledBookings.length),
                                const SizedBox(height: 10),
                                if (cancelledBookings.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                                    child: Center(
                                      child: Text(
                                        "No cancelled pujas",
                                        style: avenirNextRegular.copyWith(
                                          color: ColorResources.textLight,
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                                    ),
                                  ),
                                ...cancelledBookings.map((b) => _bookingCard(b, upcoming: false)),
                              ],

                              const SizedBox(height: 8),
                              if (activeList.isNotEmpty) const SizedBox(height: 4),
                              _statsRow(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .2),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _tabButton(int index) {
    final labels = ["Upcoming", "Completed", "Cancelled"];
    final active = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: active ? _redGradient : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              labels[index],
              style: cormorantInfantBold.copyWith(
                color: active ? Colors.white : ColorResources.textLight,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, int count) {
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
            "$count Booking${count == 1 ? '' : 's'}",
            style: avenirNextRegular.copyWith(
              color: ColorResources.textLight,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- BOOKING CARD ----------------
  Widget _bookingCard(Map<String, String> item, {required bool upcoming}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item['image']!,
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: cormorantInfantBold.copyWith(
                              color: ColorResources.blackColor,
                              fontSize: Dimensions.spacingSize16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: upcoming
                                ? const Color(0xFFE07A00)
                                : const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            upcoming ? "Upcoming" : "Completed",
                            style: cormorantInfantBold.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _iconLine(Icons.location_on_outlined, item['temple']!),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: _iconLine(Icons.calendar_month_outlined, item['date']!),
                        ),
                        Expanded(
                          child: _iconLine(Icons.access_time, item['time']!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    _iconLine(Icons.people_alt_outlined, item['family']!),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _notify(upcoming ? "Viewing booking details" : "Viewing puja summary"),
            child: Text(
              upcoming ? "View Details" : "View Summary",
              style: avenirNextCyr.copyWith(
                color: const Color(0xff9D1911),
                fontSize: Dimensions.fontSizeSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (upcoming)
            Row(
              children: [
                Expanded(
                  child: _outlineButton(
                    "Reschedule",
                    onTap: () => _notify("Reschedule ${item['title']}"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _filledButton(
                    "Contact Priest",
                    onTap: () => _notify("Contacting priest for ${item['title']}"),
                  ),
                ),
              ],
            )
          else
            _outlineButton(
              "Download Report",
              onTap: () => _notify("Downloading report for ${item['title']}"),
            ),
        ],
      ),
    );
  }

  Widget _iconLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xffF59E0B)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: avenirNextRegular.copyWith(
              color: ColorResources.textLight,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _outlineButton(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xff9D1911)),
        ),
        child: Text(
          label,
          style: cormorantInfantBold.copyWith(
            color: const Color(0xff9D1911),
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ),
    );
  }

  Widget _filledButton(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: _redGradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: cormorantInfantBold.copyWith(
            color: Colors.white,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ),
    );
  }

  /// ---------------- STATS ROW ----------------
  Widget _statsRow() {
    final total = upcomingBookings.length + completedBookings.length + cancelledBookings.length;

    final stats = [
      ("Total Bookings", total),
      ("Completed", completedBookings.length),
      ("Upcoming", upcomingBookings.length),
      ("Cancelled", cancelledBookings.length),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: Column(
                children: [
                  Text(
                    s.$2.toString().padLeft(2, '0'),
                    style: cormorantInfantBold.copyWith(
                      color: const Color(0xff9D1911),
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.$1,
                    textAlign: TextAlign.center,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
