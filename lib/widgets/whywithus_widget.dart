import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

class WhyBookWithUs extends StatelessWidget {
  const WhyBookWithUs({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    const Color orange = Color(0xFFE8A03A);
    const Color bgColor = Color(0xFFF5F1EB);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: bgColor,
      child: Column(
        children: [
          // Title
          Text(
            "Why Book With Us",
            style: cormorantInfantBold.copyWith(
              color: ColorResources.blackColor,
              fontSize: Dimensions.spacingSize30,
            ),
          ),

          //  SizedBox(height: Dimensions.spacingSize12),

          // Decorative Line
          SizedBox(height: Dimensions.spacingSize12),

          Image.asset('assets/images/group.png'),

          SizedBox(height: Dimensions.spacingSize20),

          Row(
            children: [
              Expanded(
                child: _featureItem(
                  icon: Icons.shield_outlined,
                  title: "Authentic",
                  subtitle: "Rituals",
                ),
              ),

              Container(height: 60, width: 1, color: orange.withValues(alpha: .4)),

              Expanded(
                child: _featureItem(
                  icon: Icons.groups_outlined,
                  title: "Experienced",
                  subtitle: "Purohits",
                ),
              ),

              Container(height: 60, width: 1, color: orange.withValues(alpha: .4)),

              Expanded(
                child: _featureItem(
                  icon: Icons.play_circle_outline,
                  title: "Live Puja",
                  subtitle: "Streaming",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _featureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const Color orange = Color(0xFFE8A03A);

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: orange.withValues(alpha: .12),
            border: Border.all(color: orange.withValues(alpha: .4)),
          ),
          child: Icon(icon, color: orange, size: 24),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          textAlign: TextAlign.center,
          style: cormorantInfantBold.copyWith(
            color: ColorResources.blackColor,
            fontSize: Dimensions.spacingSize18,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: cormorantInfantRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.spacingSize16,
          ),
        ),
      ],
    );
  }
}
