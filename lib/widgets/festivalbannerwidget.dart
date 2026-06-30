import 'dart:async';
import 'package:flutter/material.dart';

class FestivalBannerWidget extends StatefulWidget {
  const FestivalBannerWidget({super.key});

  @override
  State<FestivalBannerWidget> createState() => _FestivalBannerWidgetState();
}

class _FestivalBannerWidgetState extends State<FestivalBannerWidget> {
  late Timer _timer;

  final DateTime targetDate = DateTime(
    2026,
    10,
    15,
  );

  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTimer();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTimer(),
    );
  }

  void _updateTimer() {
    final diff = targetDate.difference(DateTime.now());

    setState(() {
      remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget timerBox(String value, String title) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final mins = remaining.inMinutes % 60;
    final secs = remaining.inSeconds % 60;

    return
   LayoutBuilder(
  builder: (context, constraints) {
    final bannerHeight = constraints.maxWidth * 0.42;

    return Container(
      height: bannerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          /// Background
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              "assets/images/festivalbanner.png",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// Right Side Image
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/maa.png",
              height: bannerHeight * 0.9,
              fit: BoxFit.contain,
            ),
          ),

          /// Content
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: bannerHeight * 0.7,
                right: bannerHeight * 0.5,
                top: bannerHeight * 0.10,
              ),
              child: Column(
                children: [
                  Text(
                    "Navratri Mahotsav",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFFFD47A),
                      fontSize: bannerHeight * 0.12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: bannerHeight * 0.07),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      timerBox(
                        days.toString().padLeft(2, "0"),
                        "D",
                      ),
                      timerBox(
                        hours.toString().padLeft(2, "0"),
                        "H",
                      ),
                      timerBox(
                        mins.toString().padLeft(2, "0"),
                        "M",
                      ),
                      timerBox(
                        secs.toString().padLeft(2, "0"),
                        "S",
                      ),
                    ],
                  ),

                  SizedBox(height: bannerHeight * 0.07),

                  SizedBox(
                    height: bannerHeight * 0.22,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF8B1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "View Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: bannerHeight * 0.08,
                        ),
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
  },
);
  }
}