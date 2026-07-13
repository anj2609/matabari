import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/devotee/e_darshan_screen.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class AboutTempleScreen extends StatelessWidget {
  const AboutTempleScreen({super.key});

  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  static const List<String> _galleryImages = [
    "assets/images/temple.png",
    "assets/images/dailyaarti.png",
    "assets/images/todaydarshan.png",
    "assets/images/maa1.png",
  ];

  static const List<Map<String, String>> _significance = [
    {"title": "Maa Kali", "subtitle": "Wisdom"},
    {"title": "Tripura", "subtitle": "Energy"},
  ];

  void _notify(BuildContext context, String message) {
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
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Mata Tripura Sundari",
                                  textAlign: TextAlign.center,
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.spacingSize20,
                                  ),
                                ),
                                Text(
                                  "Shaktipeeth e-Darshan",
                                  textAlign: TextAlign.center,
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.spacingSize20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _notify(context, "Sharing temple details"),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _heroCard(),
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle("About the Temple"),
                        const SizedBox(height: 8),
                        _aboutCard(),
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _eDarshanCard(context),
                        ),
                        const SizedBox(height: 20),

                        _sectionHeader("Temple Gallery"),
                        const SizedBox(height: 10),
                        _galleryRow(),
                        const SizedBox(height: 20),

                        _sectionTitle("Spiritual Significance"),
                        const SizedBox(height: 10),
                        _significanceRow(),
                        const SizedBox(height: 20),

                        _sectionTitle("Temple Timings"),
                        const SizedBox(height: 10),
                        _timingsCard(),
                        const SizedBox(height: 20),

                        _sectionTitle("Location"),
                        const SizedBox(height: 10),
                        _locationCard(),
                        const SizedBox(height: 16),

                        _contactFooter(context),
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

  /// ---------------- HERO CARD ----------------
  Widget _heroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/Tripura Sundari-Photoroom 1.png", fit: BoxFit.cover),
            Container(color: const Color(0x66650E07)),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mata Tripura Sundari Shaktipeeth",
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _heroStat(Icons.auto_awesome, "51 Shaktipeeth"),
                      const SizedBox(width: 14),
                      _heroStat(Icons.location_on_outlined, "Udaipur, Tripura"),
                      const SizedBox(width: 14),
                      _heroStat(Icons.access_time, "24x7 Darshan"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroStat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 12),
        const SizedBox(width: 3),
        Text(
          label,
          style: avenirNextRegular.copyWith(color: Colors.white, fontSize: 9),
        ),
      ],
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

  /// ---------------- ABOUT ----------------
  Widget _aboutCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Text(
          "Maa Tripura Sundari Temple is revered as one of the 51 Shaktipeethas, "
          "sacred sites where the divine mother is worshipped. Devotees from "
          "across the region visit to seek blessings of prosperity, protection "
          "and inner peace, offering prayers amid centuries of devotion and "
          "tradition.",
          style: avenirNextRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ),
    );
  }

  /// ---------------- E-DARSHAN PROMO ----------------
  Widget _eDarshanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
      decoration: BoxDecoration(
        gradient: _redGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "e-Darshan",
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  Text(
                    "Experience Live Darshan",
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Connect with the divine from anywhere",
                    style: avenirNextRegular.copyWith(
                      color: Colors.white70,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EDarshanScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_circle_fill, color: Color(0xff9D1911), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "Watch Now",
                            style: cormorantInfantBold.copyWith(
                              color: const Color(0xff9D1911),
                              fontSize: Dimensions.fontSizeDefault,
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.asset(
              "assets/images/maa1.png",
              height: 130,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- GALLERY ----------------
  Widget _galleryRow() {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _galleryImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            _galleryImages[index],
            height: 78,
            width: 78,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// ---------------- SIGNIFICANCE ----------------
  Widget _significanceRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _significance.map((item) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, color: ColorResources.kOrange, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    item['title']!,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
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
          );
        }).toList(),
      ),
    );
  }

  /// ---------------- TIMINGS ----------------
  Widget _timingsCard() {
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
        child: Column(
          children: [
            _timingRow(Icons.wb_sunny_outlined, "Morning Darshan", "06:30 AM - 12:00 PM"),
            const Divider(color: Color(0xffF3D8B3), height: 20),
            _timingRow(Icons.nightlight_round, "Evening Darshan", "04:00 PM - 09:00 PM"),
          ],
        ),
      ),
    );
  }

  Widget _timingRow(IconData icon, String title, String time) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: const BoxDecoration(color: Color(0xFFFFF4E6), shape: BoxShape.circle),
          child: Icon(icon, color: ColorResources.kOrange, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: cormorantInfantBold.copyWith(
              color: ColorResources.blackColor,
              fontSize: Dimensions.spacingSize16,
            ),
          ),
        ),
        Text(
          time,
          style: avenirNextRegular.copyWith(
            color: const Color(0xff9D1911),
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ],
    );
  }

  /// ---------------- LOCATION ----------------
  Widget _locationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 110,
                width: double.infinity,
                color: const Color(0xFFEFE3D0),
                child: const Icon(Icons.map_outlined, color: Color(0xff9D1911), size: 34),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: ColorResources.kOrange, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Udaipur, Gomati District, Tripura - 799120",
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- CONTACT FOOTER ----------------
  Widget _contactFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _notify(context, "Calling +91 98765 43210"),
              child: Row(
                children: [
                  const Icon(Icons.call_outlined, color: Color(0xff9D1911), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "+91 98765 43210",
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _notify(context, "Opening www.matadarshan.org"),
              child: Row(
                children: [
                  const Icon(Icons.language, color: Color(0xff9D1911), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "www.matadarshan.org",
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
