import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/controller/allpuja_controller.dart';

class PujaScreen extends StatelessWidget {
  PujaScreen({super.key});
  final AllPujaController controller = Get.put(AllPujaController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.bgColors,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorResources.primary, ColorResources.textRedColor],
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // circleIcon(Icons.arrow_back_ios_new),
                        // const Spacer(),
                        Text(
                          "Puja Seva",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.kOrange,
                            fontSize: Dimensions.spacingSize14,
                          ),
                        ),

                        //circleIcon(Icons.search),
                      ],
                    ),

                    SizedBox(height: Dimensions.fontSizeSmall),

                    Text(
                      "Book authentic pujas at",
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.kOrange,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Mata Tripura Sundari Shaktipeeth",
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.kOrange,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),

                    SizedBox(height: 15),

                    Image.asset(
                      'assets/images/group.png',
                      color: ColorResources.kOrange,
                    ),
                  ],
                ),
              ),
            ),

            /// BODY
           Expanded(
  child: Container(
    decoration: const BoxDecoration(
      color: Color(0xffF8F5F0),
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      children: [
        const SizedBox(height: 18),

        /// CATEGORY (NO Expanded HERE)
        SizedBox(
          height: 90,
          child: GetBuilder<AllPujaController>(
            builder: (controller) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => controller.changeCategory(index),
                    child: category(
                      icon: controller.categories[index]['icon'],
                      title: controller.categories[index]['title'],
                      selected: controller.selectedCategory == index,
                    ),
                  );
                },
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
                  Text("All Pujas", style: cormorantInfantBold),
                  Text("86 Pujas", style: cormorantInfantRegular),
                ],
              ),
              const Spacer(),
              const Text("Sort by Popular"),
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
    required IconData icon,
    required String title,
    bool selected = false,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 12),
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
            child: Icon(icon, color: selected ? Colors.white : Colors.orange),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 65,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: cormorantInfantBold.copyWith(
                color: ColorResources.blackColor,
                fontSize: Dimensions.spacingSize12,
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

  const PujaCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
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
                width: 110,
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
                    top: 12,
                    bottom: 12,
                    right: 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.spacingSize20,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        description,
                        maxLines: 2,
                        style: cormorantInfantRegular.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.spacingSize18,
                        ),
                      ),

                      //Spacer(),
                      SizedBox(height: Dimensions.hight13),

                      Row(
                        children: [
                          _chip(Icons.access_time, duration),
                          SizedBox(width: 5),
                          _chip(Icons.live_tv, duration),
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
            child: Container(
              height: 38,
              width: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFE07A00),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.045,
              decoration: const BoxDecoration(
                color: Color(0xFFE07A00),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Center(
                child: Text(
                  price,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.whiteColor,
                    fontSize: Dimensions.spacingSize18,
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
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 9, color: Colors.orange),
          SizedBox(width: 3),
          Text(
            text,
            style: cormorantInfantBold.copyWith(
              color: ColorResources.kOrange,
              fontSize: Dimensions.spacingSize12,
            ),
          ),
        ],
      ),
    );
  }
}
