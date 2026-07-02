import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/banners_widgets.dart';
import 'package:matabari/widgets/festivalbannerwidget.dart';
import 'package:matabari/widgets/main_carousel.dart';
import 'package:matabari/widgets/pandit_card.dart';
import 'package:matabari/widgets/product_card.dart';
import 'package:matabari/widgets/testimonialcard.dart';
import 'package:matabari/widgets/upcommingpuja_widget.dart';
import 'package:matabari/widgets/whywithus_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=12",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jai Maa Tripura Sundari 🙏",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.primary,
                            fontSize: Dimensions.spacingSize18,
                          ),
                        ),
                        Text(
                          "Welcome, Devotee",
                          style: cormorantInfantRegular.copyWith(
                            color: ColorResources.blackColor,
                            // fontSize: Dimensions.spacingSize18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none, size: 28),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.search, size: 28),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorResources.border,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/mabanner.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Dark Overlay (Optional)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            //   colors: [
                            //     ColorResources.border,
                            //     ColorResources.blackColor,
                            //   ],
                            // ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: EdgeInsets.all(Dimensions.radiusSize),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Experience Divine\nBlessings Digitally",
                              style: cormorantInfantBold.copyWith(
                                color: ColorResources.primary,
                                fontSize: Dimensions.spacingSize25,
                              ),
                              // TextStyle(
                              //   fontSize: 24,
                              //   fontWeight: FontWeight.bold,
                              //   color: Colors.white,
                              //   height: 1.2,
                              // ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Book Puja, order prasad &\nattend aarti from anywhere.",
                              style: cormorantInfantRegular.copyWith(
                                color: ColorResources.blackColor,
                                fontSize: Dimensions.spacingSize12,
                              ),
                            ),

                            const Spacer(),

                            Row(
                              children: [
                                // Custom Book Puja Button
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B1E1E),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Book Puja",
                                      style: cormorantInfantBold.copyWith(
                                        color: ColorResources.whiteColor,
                                        fontSize: Dimensions.spacingSize18,
                                      ),
                                      // style: TextStyle(
                                      //   color: Colors.white,
                                      //   fontWeight: FontWeight.w600,
                                      // ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Custom Watch Aarti Button
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.20),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Watch Aarti",
                                      style: cormorantInfantBold.copyWith(
                                        color: ColorResources.primary,
                                        fontSize: Dimensions.spacingSize18,
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
                ),
              ),

              const SizedBox(height: 22),

              /// Services
              Row(
                children: [
                  Expanded(
                    child: serviceCard(
                      "assets/images/bookpuja.png",
                      "Book Puja",
                      "Perform Puja Online",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: serviceCard(
                      "assets/images/prasad1.png",
                      "Order Prasad",
                      "Sacred Prasad Delivery",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: serviceCard(
                      "assets/images/dailyaarti.png",
                      "Daily Aarti",
                      "Aarti, Chalisa & Bhajan",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// Festival Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Festivals",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text(
                    "View All",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ///===================== Festival Banner =================///////////
              FestivalBannerWidget(),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Darshan",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text(
                    "View All",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ///===================== Today Darshan Banner =================///////////
              TodayDarshanWidgets(),
              const SizedBox(height: 20),

              ///Featured Pujas
              /////////////==========   Featured Pujas    ==========//////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Pujas",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text(
                    "View All",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PujaCarousel(),
              const SizedBox(height: 20),
              /////////////==========   Upcoming Pujas    ==========//////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Pujas",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text(
                    "View All",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              UpcommingPujaScreen(),
              const SizedBox(height: 20),

              /////////////==========   WhyBookWithUs    ==========//////////////////
              WhyBookWithUs(),
              const SizedBox(height: 20),

              /////////////==========   AartiWidgets    ==========//////////////////
              AartiWidgets(),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Prasad Store",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text(
                    "View All",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductCard(
                      imageUrl: "assets/images/laddu.png",
                      title: "Motichoor Ladoo",
                      price: "₹251/-",
                      onAdd: () {},
                    ),
                    ProductCard(
                      imageUrl: "assets/images/prasad.png",
                      title: "Panchmeva",
                      price: "₹301/-",
                      onAdd: () {},
                    ),
                    ProductCard(
                      imageUrl: "assets/images/kumkum.png",
                      title: "Kumkum",
                      price: "₹101/-",
                      onAdd: () {},
                    ),
                    ProductCard(
                      imageUrl: "assets/images/ramdana.png",
                      title: "Ramdana",
                      price: "₹201/-",
                      onAdd: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pandit Ji",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text("View All", style: TextStyle(color: Color(0xFF8B1E1E))),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    PanditCard(
                      imageUrl: "assets/images/pandit1.jpg",
                      name: "Pandit Rajesh Shastri",
                      experience: "35+ Year's Exp.",
                      rating: "4.8",
                      onTap: () {
                        print("Rajesh Clicked");
                      },
                    ),

                    const SizedBox(width: 12),

                    PanditCard(
                      imageUrl: "assets/images/pandit2.jpg",
                      name: "Pandit Vishnu Sharma",
                      experience: "20+ Year's Exp.",
                      rating: "4.7",
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),

                    PanditCard(
                      imageUrl: "assets/images/pandit3.png",
                      name: "Pandit Vishnu Sharma",
                      experience: "20+ Year's Exp.",
                      rating: "4.7",
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),

                    PanditCard(
                      imageUrl: "assets/images/pandit1.jpg",
                      name: "Pandit Vishnu Sharma",
                      experience: "20+ Year's Exp.",
                      rating: "4.7",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              DevotionBanner(),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Devotee Testimonials",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize20,
                    ),
                  ),
                  Text(
                    "View All",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TestimonialCard(),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "All Right Reserve to",
                  textAlign: TextAlign.center,
                  style: cormorantInfantRegular.copyWith(
                    color: ColorResources.primary,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
              ),

              /// Title
              Center(
                child: Text(
                  "Maa Tripura Sundari Shaktipeeth e-Darshan",
                  textAlign: TextAlign.center,
                  style: cormorantInfantSemiBold.copyWith(
                    color: ColorResources.primary,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
              ),

              SizedBox(height: 10),

              Center(child: Image.asset('assets/images/group.png')),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Design & Developed by",
                  textAlign: TextAlign.center,
                  style: cormorantInfantRegular.copyWith(
                    color: ColorResources.primary,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
              ),

              /// Title
              Center(
                child: Text(
                  "Infiniti Tech Solution",
                  textAlign: TextAlign.center,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.secondary,
                    fontSize: Dimensions.spacingSize25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(String imagess, String title, String subtitle) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8ED),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6C98D)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagess, height: 30),

            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: cormorantInfantBold.copyWith(
                color: ColorResources.blackColor,
                fontSize: Dimensions.spacingSize16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: cormorantInfantBold.copyWith(
                color: ColorResources.textLight,
                fontSize: Dimensions.spacingSize12,
              ),
            ),
          ],
        ),
      ),
    );
  }



}
