import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

class TestimonialCard extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String imageUrl;

  const TestimonialCard({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6C98D), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Profile Image
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE6C98D), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, color: ColorResources.textLight)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, color: ColorResources.textLight),
                      ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '❝ ',
                        style: TextStyle(
                          color: Color(0xFFE67E22),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: comment,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.textLight,
                          fontSize: Dimensions.spacingSize12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "- $name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.textLight,
                          fontSize: Dimensions.spacingSize12,
                        ),
                      ),
                    ),

                    Row(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: const Color(0xFFE67E22),
                            size: 10,
                          ),
                        ),
                      ),
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
}
