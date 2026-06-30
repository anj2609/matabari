import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matabari/widgets/banners_widgets.dart';

class PujaCarousel extends StatefulWidget {
  const PujaCarousel({super.key});

  @override
  State<PujaCarousel> createState() => _PujaCarouselState();
}

class _PujaCarouselState extends State<PujaCarousel> {
  int currentIndex = 0;

  final banners = [
    "assets/images/featurebanner.png",
    "assets/images/featurebanner.png",
    "assets/images/featurebanner.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
           height: MediaQuery.of(context).size.height * 0.42,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return PujaBanner(
              image: banners[index],
            );
          },
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              width: currentIndex == index ? 20 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? const Color(0xffC43B31)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}