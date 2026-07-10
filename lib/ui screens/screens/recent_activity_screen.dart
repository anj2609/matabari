import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key});

  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  static const List<Map<String, dynamic>> _activityGroups = [
    {
      "date": "Today",
      "items": [
        {
          "title": "Maa Tripura Sundari Puja Booked",
          "time": "10:30 AM",
          "ref": "Booking ID: #PB1234",
          "type": "booking",
          "image": "assets/images/Rectangle 693.png",
        },
        {
          "title": "Prasad Box Ordered",
          "time": "09:15 AM",
          "ref": "Order ID: #PO5678",
          "type": "order",
          "image": "assets/images/prasad.png",
        },
        {
          "title": "Shri Sunder Kaand Played",
          "time": "08:00 AM",
          "ref": "Aarti ID: #A1234",
          "type": "played",
          "image": "assets/images/dailyaarti.png",
        },
      ],
    },
    {
      "date": "Yesterday",
      "items": [
        {
          "title": "Navgraha Shanti Puja Booked",
          "time": "06:45 PM",
          "ref": "Booking ID: #PB1198",
          "type": "booking",
          "image": "assets/images/Rectangle 720.png",
        },
        {
          "title": "Coconut Ordered",
          "time": "05:20 PM",
          "ref": "Order ID: #PO5601",
          "type": "order",
          "image": "assets/images/Rectangle 666.png",
        },
        {
          "title": "Hanuman Chalisa Saved",
          "time": "03:10 PM",
          "ref": "Saved ID: #S3321",
          "type": "saved",
          "image": "assets/images/hanumanji.png",
        },
      ],
    },
    {
      "date": "23 May 2026",
      "items": [
        {
          "title": "Achyutam Keshavam Played",
          "time": "07:30 AM",
          "ref": "Bhajan ID: #B4432",
          "type": "played",
          "image": "assets/images/temple.png",
        },
        {
          "title": "Chunri Ordered",
          "time": "06:15 PM",
          "ref": "Order ID: #PO5480",
          "type": "order",
          "image": "assets/images/Rectangle 673.png",
        },
      ],
    },
  ];

  static const Map<String, (IconData, Color)> _typeStyles = {
    "booking": (Icons.event_available_outlined, Color(0xff9D1911)),
    "order": (Icons.shopping_bag_outlined, Color(0xFFE07A00)),
    "played": (Icons.play_circle_outline, Color(0xFF2E7D32)),
    "saved": (Icons.bookmark_outline, Color(0xFFE07A00)),
  };

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
              _header(context),
              const SizedBox(height: 16),
              for (final group in _activityGroups) ...[
                _dateHeader(group['date'] as String),
                const SizedBox(height: 8),
                ...(group['items'] as List<Map<String, String>>).map(_activityRow),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: _redGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
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
                  "Recent Activity",
                  style: cormorantInfantBold.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.spacingSize22,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Your recent bookings & activity",
                  style: avenirNextRegular.copyWith(
                    color: Colors.white70,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: .2),
            ),
            child: const Icon(Icons.history, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _dateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _gradientText(
        date,
        cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize16),
      ),
    );
  }

  /// ---------------- ACTIVITY ROW ----------------
  Widget _activityRow(Map<String, String> item) {
    final style = _typeStyles[item['type']] ?? _typeStyles['booking']!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item['image']!,
              height: 52,
              width: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize14,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(style.$1, size: 12, color: style.$2),
                    const SizedBox(width: 4),
                    Text(
                      item['time']!,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item['ref']!,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
