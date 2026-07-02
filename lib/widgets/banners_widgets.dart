import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/button_screen.dart';

class TodayDarshanWidgets extends StatefulWidget {
  const TodayDarshanWidgets({super.key});

  @override
  State<TodayDarshanWidgets> createState() => _TodayDarshanWidgetsState();
}

class _TodayDarshanWidgetsState extends State<TodayDarshanWidgets> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerHeight = constraints.maxWidth * 0.42;

        return Container(
          height: bannerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.spacingSize18),
          ),
          child: Stack(
            children: [
              /// Background
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.spacingSize18),
                child: Image.asset(
                  "assets/images/todaydarshan.png",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

////// ========= Featured Pujas ======================///////////

class PujaBanner extends StatelessWidget {
  final String image;

  const PujaBanner({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.spacingSize20),
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: .65),
                    Colors.black.withValues(alpha: .30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Maa",
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.kGold,
                          fontSize: Dimensions.spacingSize25,
                        ),
                      ),
                      Container(
                        height: width * .13,
                        width: width * .13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * .025),
                        ),
                        child: Icon(Icons.bookmark_border, size: width * .05),
                      ),
                    ],
                  ),

                  // SizedBox(height: 0.2),
                  Text(
                    "Tripura\nSundari",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.whiteColor,
                      fontSize: Dimensions.spacingSize25,
                    ),
                  ),

                  Text(
                    "Mahapuja",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.kGold,
                      fontSize: Dimensions.spacingSize25,
                    ),
                  ),

                  SizedBox(height: width * .013),

                  SizedBox(
                    width: width * .50,
                    child: Text(
                      "Invoke blessings of prosperity, love & beauty",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.whiteColor,
                        fontSize: Dimensions.spacingSize18,
                      ),
                    ),
                  ),

                  SizedBox(height: width * .02),
                  Row(
                    children: [
                      Expanded(
                        child: _glassCard(
                          context,
                          Icons.access_time,
                          "2 Hours",
                          "Duration",
                        ),
                      ),
                      SizedBox(width: width * .02),
                      Expanded(
                        child: _glassCard(
                          context,
                          Icons.videocam_outlined,
                          "Live",
                          "Streaming",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: width * .05),

                  Row(
                    children: [
                      SizedBox(
                        width: width * .18,
                        height: width * .08,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: width * .032,
                              backgroundImage: const AssetImage(
                                "assets/images/user.png",
                              ),
                            ),
                            Positioned(
                              left: width * .045,
                              child: CircleAvatar(
                                radius: width * .032,
                                backgroundImage: const AssetImage(
                                  "assets/images/user.png",
                                ),
                              ),
                            ),
                            Positioned(
                              left: width * .09,
                              child: CircleAvatar(
                                radius: width * .032,
                                backgroundImage: const AssetImage(
                                  "assets/images/user.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Text(
                          "3.5k+ Devotees\nbooked this puja",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.whiteColor,
                            fontSize: Dimensions.smallSize,
                          ),
                        ),
                      ),
                   
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * .08,
                          vertical: width * .03,
                        ),
                        decoration: BoxDecoration(
                          color: ColorResources.primary,
                          borderRadius: BorderRadius.circular(width * .03),
                        ),
                        child: Text(
                          "Book Puja",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.whiteColor,
                            fontSize: Dimensions.spacingSize16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  
  }

  Widget _glassCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * .025,
        vertical: width * .015,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6D1F1F), Color(0xFF4A1414)],
        ),
        border: Border.all(color: const Color(0xFFE6C98D), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: width * .07,
            width: width * .07,
            decoration: BoxDecoration(
              color: const Color(0xFF7A2B2B),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE6C98D), width: .8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFE6C98D),
              size: width * .035,
            ),
          ),

          SizedBox(width: width * .02),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * .022,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                subtitle,
                style: TextStyle(
                  color: const Color(0xFFFFC857),
                  fontSize: width * .028,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/////////===================== home banner Widgets ======================/////////////////////////

class AartiWidgets extends StatefulWidget {
  const AartiWidgets({super.key});

  @override
  State<AartiWidgets> createState() => _AartiWidgetsState();
}

class _AartiWidgetsState extends State<AartiWidgets> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerHeight = constraints.maxWidth * 1;

        return Container(
          height: bannerHeight,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
          child: Stack(
            children: [
              /// Background
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  "assets/images/banner2.png",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

///////// ====================== banner  ==================//////////////////

class DevotionBanner extends StatelessWidget {
  const DevotionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Full Banner Background
            Image.asset("assets/images/temple.png", fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withValues(alpha: .05), Colors.transparent],
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 90),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '❝ ',
                        style: TextStyle(
                          color: Color(0xFFE27A2E),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Let devotion be your path\nand Maa your strength.',
                        style: TextStyle(
                          color: Color(0xFFB55B2A),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Serif',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
