import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/controller/allpuja_controller.dart';
import 'package:matabari/ui%20screens/screens/devotee/puja_detail_screen.dart';

class PujaScreen extends StatelessWidget {
  PujaScreen({super.key});
  final AllPujaController controller = Get.put(AllPujaController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/Group 31.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Image.asset(
                            'assets/images/Rectangle 689.png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                        Text(
                          "Puja Seva",
                          style: cormorantInfantBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.spacingSize22,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/Icon (1).png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.fontSizeSmall),

                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFFABB46),
                          Color(0xFFFEF39E),
                          Color(0xFFF2C639),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ).createShader(bounds),
                      child: Text(
                        "Book authentic pujas at\nMata Tripura Sundari Shaktipeeth",
                        textAlign: TextAlign.center,
                        style: avenirNextCyr.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Image.asset(
                      'assets/images/Frame.png',
                      height: 14,
                      color: const Color(0xFFFEF39E),
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
    child: Column(
      children: [
        const SizedBox(height: 18),

        /// CATEGORY (NO Expanded HERE)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GetBuilder<AllPujaController>(
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  controller.categories.length,
                  (index) => GestureDetector(
                    onTap: () => controller.changeCategory(index),
                    child: category(
                      icon: controller.categories[index]['icon'],
                      title: controller.categories[index]['title'],
                      selected: controller.selectedCategory == index,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        /// HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Pujas",
                    style: cormorantInfantBold.copyWith(
                      fontSize: 14.0,
                      color: ColorResources.blackColor,
                    ),
                  ),
                  Text(
                    "86 Pujas",
                    style: avenirNextCyr.copyWith(
                      fontSize: 10.0,
                      color: ColorResources.blackColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    "Sort by ",
                    style: avenirNextCyr.copyWith(
                      fontSize: 10.0,
                      color: ColorResources.blackColor,
                    ),
                  ),
                  Text(
                    "Popular",
                    style: avenirNextCyr.copyWith(
                      fontSize: 10.0,
                      color: const Color(0xFFDF7004),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Color(0xFFDF7004),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        /// LIST (ONLY THIS IS EXPANDED)
        Expanded(
          child: GetBuilder<AllPujaController>(
            builder: (controller) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: controller.pujaList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.pujaList[index];

                  return PujaCard(
                    title: item['title'] ?? '',
                    description: item['description'] ?? '',
                    image: item['image'] ?? '',
                    price: item['price'] ?? '',
                    duration: item['duration'] ?? '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PujaDetailScreen(puja: item),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  ),
)
         
          ],
        ),
        ),
      ),
    );
  }

  Widget circleIcon(IconData icon) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .15),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget category({
    required String icon,
    required String title,
    bool selected = false,
  }) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: selected ? const Color(0xff8F1206) : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Image.asset(
                icon,
                height: 29,
                width: 44,
                fit: BoxFit.contain,
                color: selected ? Colors.white : Colors.orange,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class PujaCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String price;
  final String duration;
  final VoidCallback onTap;

  const PujaCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 378,
      constraints: const BoxConstraints(minHeight: 131),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 134,
                height: 121,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    top: 8,
                    bottom: 8,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.spacingSize16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        description,
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),

                      //Spacer(),
                      const SizedBox(height: 6),

                      Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: [
                          _chip(Icons.access_time, duration),
                          _chip(Icons.live_tv, "Video Available"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFE07A00),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 52,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFE07A00),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Center(
                child: Text(
                  price,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.whiteColor,
                    fontSize: Dimensions.spacingSize14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 8, color: Colors.orange),
          SizedBox(width: 2),
          Text(
            text,
            style: cormorantInfantBold.copyWith(
              color: ColorResources.kOrange,
              fontSize: Dimensions.spacingSize11,
            ),
          ),
        ],
      ),
    );
  }
}
