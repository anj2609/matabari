import 'package:flutter/material.dart';
import 'package:matabari/widgets/button_screen.dart';
import 'package:matabari/models/onboarding_model.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentIndex = 0;
  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: "assets/images/onboarding1.png",
      title: "Anytime, Anywhere",
      subtitle:
          "Connect with Mata Tripura Sundari through live darshan, daily blessings, and spiritual experiences from your mobile device.",
      features: [],
      buttonText: "Next",
      group: 'assets/images/group.png',
    ),
    OnboardingModel(
      image: "assets/images/onboarding2.png",
      title: "Book Puja with Ease",
      subtitle:
          "Schedule personalized pujas, select Pandit Ji, add chadhava, and receive blessings digitally.",
      features: ["Personalized Puja", "Trusted Pandit Ji", "Instant Booking"],
      buttonText: "Next",
      group: 'assets/images/group.png',
    ),
    OnboardingModel(
      image: "assets/images/onboarding3.png",
      title: "Send Your Devotion from Anywhere",
      subtitle:
          "Order prasad directly from trusted temple vendors and get it offered on your behalf.",
      features: ["Verified Vendors", "Easy Ordering", "Trusted Vendors"],
      buttonText: "Next",
      group: 'assets/images/group.png',
    ),
    OnboardingModel(
      image: "assets/images/onboarding4.png",
      title: "Daily Aarti & Spiritual Guidance",
      subtitle:
          "Listen to sacred aartis, explore chalisa, receive festival updates, and experience divine presence every day.",
      features: ["Festival Updates", "Chalisa Collection", "Daily Bhajans"],
      buttonText: "Continue",
      group: 'assets/images/group.png',
    ),
  ];

  void nextPage() {
    if (currentIndex == onboardingData.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthLoginScreen()),
      );
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),

          PageView.builder(
            controller: pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = onboardingData[index];

              return Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: size.height * .45,
                        width: double.infinity,
                        child: Image.asset(
                          item.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),

                      /// Skip Button Overlay
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthLoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            SmoothPageIndicator(
                              controller: pageController,
                              count: onboardingData.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: const Color(0xffA61D2A),
                                dotColor: Colors.grey.shade300,
                                dotHeight: 8,
                                dotWidth: 8,
                              ),
                            ),

                            const SizedBox(height: 25),

                            const Text(
                              "|| Jai Mata Di ||",
                              style: TextStyle(
                                color: Color(0xffA61D2A),
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 34,
                                color: Color(0xffA61D2A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Image.asset(item.group),

                            const SizedBox(height: 15),

                            Text(
                              item.subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),

                            Spacer(),

                            CustomButton(
                              title: item.buttonText,
                              onTap: nextPage,
                            ),

                            SizedBox(height: size.height * .04),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
