import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

class PanditCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String experience;
  final String rating;
  final VoidCallback onTap;

  const PanditCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.experience,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.height * 0.20,
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffF3D8B3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.asset(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Rating Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffFF9F0A),
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          rating,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize11,
                          ),
                        ),
                      ],
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
                  /// Name
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Experience
                  Text(
                    experience,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Book Now Button
                  Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffE57D0A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Text(
                      "Book Now",
                      style: cormorantInfantBold.copyWith(
                      color: ColorResources.whiteColor,
                      fontSize: Dimensions.spacingSize16,
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
}
