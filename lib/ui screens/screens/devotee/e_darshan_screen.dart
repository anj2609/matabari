import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class EDarshanScreen extends StatefulWidget {
  const EDarshanScreen({super.key});

  @override
  State<EDarshanScreen> createState() => _EDarshanScreenState();
}

class _EDarshanScreenState extends State<EDarshanScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  bool isPlaying = true;

  static const List<Map<String, String>> _todaySeva = [
    {"icon": "flame", "title": "Maha Aarti", "time": "06:30 AM"},
    {"icon": "bowl", "title": "Bhog Offering", "time": "12:00 PM"},
    {"icon": "diya", "title": "Deepdaan", "time": "07:00 PM"},
  ];

  static const List<Map<String, String>> _upcomingEvents = [
    {
      "title": "Sankhya Aarti",
      "when": "Today",
      "time": "06:30 PM",
      "image": "assets/images/dailyaarti.png",
    },
    {
      "title": "Special Puja",
      "when": "Tomorrow",
      "time": "09:00 AM",
      "image": "assets/images/todaydarshan.png",
    },
  ];

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
                            child: _circleIconButton(Icons.arrow_back),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "e-Darshan",
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.spacingSize22,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Mata Tripura Sundari Temple",
                                  style: avenirNextRegular.copyWith(
                                    color: Colors.white70,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _notify("Notifications enabled for live darshan"),
                            child: _circleIconButton(Icons.notifications_none),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _notify("Sharing live darshan"),
                            child: _circleIconButton(Icons.share_outlined),
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
                          child: _liveVideoCard(),
                        ),
                        const SizedBox(height: 22),

                        _sectionTitle("Temple Timings"),
                        const SizedBox(height: 10),
                        _timingsCard(),
                        const SizedBox(height: 22),

                        _sectionTitle("Today Seva"),
                        const SizedBox(height: 10),
                        _sevaCard(),
                        const SizedBox(height: 22),

                        _sectionTitle("Upcoming Events"),
                        const SizedBox(height: 10),
                        _upcomingEventsRow(),
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

  Widget _circleIconButton(IconData icon) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .2),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  /// ---------------- LIVE VIDEO CARD ----------------
  Widget _liveVideoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/maa1.png", fit: BoxFit.cover),
            Container(color: const Color(0x33650E07)),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "LIVE",
                      style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => isPlaying = !isPlaying),
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  /// ---------------- TEMPLE TIMINGS ----------------
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
            _iconRow(Icons.wb_sunny_outlined, "Morning Darshan", "06:00 AM - 12:00 PM"),
            const Divider(color: Color(0xffF3D8B3), height: 20),
            _iconRow(Icons.nightlight_round, "Evening Darshan", "04:00 PM - 09:00 PM"),
          ],
        ),
      ),
    );
  }

  /// ---------------- TODAY SEVA ----------------
  Widget _sevaCard() {
    final icons = {
      "flame": Icons.local_fire_department_outlined,
      "bowl": Icons.rice_bowl_outlined,
      "diya": Icons.emoji_objects_outlined,
    };

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
          children: List.generate(_todaySeva.length, (index) {
            final item = _todaySeva[index];
            final isLast = index == _todaySeva.length - 1;
            return Column(
              children: [
                _iconRow(icons[item['icon']]!, item['title']!, item['time']!),
                if (!isLast) const Divider(color: Color(0xffF3D8B3), height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String title, String time) {
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

  /// ---------------- UPCOMING EVENTS ----------------
  Widget _upcomingEventsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _upcomingEvents.map((event) {
          return Expanded(
            child: GestureDetector(
              onTap: () => _notify("Reminder set for ${event['title']}"),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffF3D8B3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          child: Image.asset(
                            event['image']!,
                            height: 76,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE07A00),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: cormorantInfantBold.copyWith(
                              color: ColorResources.blackColor,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                          Text(
                            "${event['when']} • ${event['time']}",
                            style: avenirNextRegular.copyWith(
                              color: ColorResources.textLight,
                              fontSize: 9,
                            ),
                          ),
                        ],
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
