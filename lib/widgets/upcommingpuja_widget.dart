import 'package:flutter/material.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/widgets/homecards_widget.dart';

class UpcommingPujaScreen extends StatefulWidget {
  const UpcommingPujaScreen({super.key});

  @override
  State<UpcommingPujaScreen> createState() => _UpcommingPujaScreenState();
}

class _UpcommingPujaScreenState extends State<UpcommingPujaScreen> {
  int currentIndex = 0;

  final List<String> pujaImages = [
    "assets/images/card.png",
    "assets/images/card1.png",
    "assets/images/card.png",
    "assets/images/card1.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding:  EdgeInsets.symmetric(horizontal: Dimensions.radiusSizeDefault),
        scrollDirection: Axis.horizontal,
        itemCount: pujaImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return UpcomingPujaCard(image: pujaImages[index]);
        },
      ),
    );
  }
}
