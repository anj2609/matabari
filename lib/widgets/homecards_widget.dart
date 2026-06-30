import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

class UpcomingPujaCard extends StatelessWidget {
  final String image;

  const UpcomingPujaCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.height * 0.25,
      height:MediaQuery.of(context).size.height * 0.42,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),

            /// Orange Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xffF59E0B).withOpacity(.35),
                      const Color(0xff5B2500).withOpacity(.75),
                      const Color(0xff1A0B05),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  /// Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5B942),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "UPCOMING",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize11,
                          ),
                        ),
                      ),

                      Container(
                        width: 30,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "24",
                              style: cormorantInfantSemiBold.copyWith(
                                color: ColorResources.primary,
                                fontSize: Dimensions.spacingSize12,
                              ),
                            ),
                            Text(
                              "JUN",
                              style: cormorantInfantSemiBold.copyWith(
                                color: ColorResources.blackColor,
                                fontSize: Dimensions.spacingSize12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Maha Laxmi Pujan",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.whiteColor,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 10,
                        color: Color(0xffFBBF24),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "1.5 Hours",
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.kOrange,
                          fontSize: Dimensions.spacingSize12,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.calendar_today,
                        size: 10,
                        color: Color(0xffFBBF24),
                      ),
                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          "24 Jun, 2026",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.kOrange,
                            fontSize: Dimensions.spacingSize12,
                          ),
                        ),
                      ),

                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Color(0xff8B1E14),
                        ),
                      ),
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
}
