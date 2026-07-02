import 'package:flutter/material.dart';
import 'package:matabari/widgets/button_screen.dart';
import 'package:matabari/models/onboarding_model.dart';
import 'package:matabari/config/utils/onboarding_prefs.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';
import 'package:matabari/widgets/skip_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  static const Color _red = Color(0xff9D1911);

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: "assets/images/onboarding1.png",
      header: "Experience Divine Darshan",
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
      title: "Send Your Devotion\nfrom Anywhere",
      subtitle:
          "Order prasad directly from trusted temple vendors and get it offered on your behalf.",
      features: ["Verified Vendors", "Easy Ordering", "Trusted Delivery"],
      buttonText: "Next",
      group: 'assets/images/group.png',
      titleFontSize: 34,
    ),
    OnboardingModel(
      image: "assets/images/onboarding4.png",
      title: "Daily Aarti &\nSpiritual Guidance",
      subtitle:
          "Listen to sacred aartis, explore chalisa, receive festival updates, and experience divine presence every day.",
      features: ["Festival Updates", "Chalisa Collection", "Daily Bhajans"],
      buttonText: "Continue",
      group: 'assets/images/group.png',
      titleFontSize: 34,
    ),
  ];

  // Icons for each screen's feature chips
  final List<List<IconData>> _featureIcons = [
    [],
    [], // Screen 2 uses images instead
    [
      Icons.verified_outlined,
      Icons.local_shipping_outlined,
      Icons.star_outline,
    ],
    [
      Icons.calendar_today_outlined,
      Icons.auto_stories_outlined,
      Icons.music_note_outlined,
    ],
  ];

  // Image paths for feature chips (used instead of icons when available)
  final List<List<String>> _featureImages = [
    [],
    [
      'assets/images/User.png',
      'assets/images/Trusted.png',
      'assets/images/Online booking.png',
    ],
    [
      'assets/images/Check.png',
      'assets/images/Shopping bag.png',
      'assets/images/Vendor.png',
    ],
    [
      'assets/images/Notification.png',
      'assets/images/Scripture.png',
      'assets/images/Online booking.png',
    ],
  ];

  void _nextPage() {
    if (currentIndex == onboardingData.length - 1) {
      _goToLogin();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToLogin() => _goToLogin();

  // Marks onboarding as seen (so it never shows again) and opens the
  // mobile-number (login) screen.
  Future<void> _goToLogin() async {
    await OnboardingPrefs.setSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthLoginScreen()),
    );
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
          // Warm parchment background
          Positioned.fill(
            child: Image.asset(
              "assets/images/Spash_screen_background 1.png",
              fit: BoxFit.cover,
            ),
          ),

          PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: onboardingData.length,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (context, index) {
              final item = onboardingData[index];
              final icons = _featureIcons[index];

              return Column(
                children: [
                  // ── Top image section ──────────────────────────
                  SizedBox(
                    height: size.height * 0.50,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image clipped with rounded bottom corners + layered effects
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Base image
                              Transform.scale(
                                scale: 1.18,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  item.image,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),

                              // Warm golden glow concentrated at the divine halo (upper centre)
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment(0, -0.55),
                                    radius: 0.6,
                                    colors: [
                                      Color(0x35FFD54F),
                                      Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),

                              // Left-edge vignette
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 55,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0x28000000),
                                        Color(0x00000000),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Right-edge vignette
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 55,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [
                                        Color(0x28000000),
                                        Color(0x00000000),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Bottom fade — tall, multi-stop for a natural cream blend
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 160,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: const [0.0, 0.45, 1.0],
                                      colors: [
                                        const Color(
                                          0xFFF5ECD5,
                                        ).withValues(alpha: 1.0),
                                        const Color(
                                          0xFFF5ECD5,
                                        ).withValues(alpha: 0.55),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Skip button — sits above ClipRRect so it is not clipped
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          right: 16,
                          child: SkipButton(onTap: _skipToLogin),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),

                                    // Page indicator dots
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xffC42118),
                                              Color(0xff9D1911),
                                              Color(0xff650E07),
                                            ],
                                            stops: [0.0, 0.45, 1.0],
                                          ).createShader(bounds),
                                      blendMode: BlendMode.srcIn,
                                      child: SmoothPageIndicator(
                                        controller: pageController,
                                        count: onboardingData.length,
                                        effect: const ExpandingDotsEffect(
                                          activeDotColor: Color(0xff9D1911),
                                          dotColor: Color(0xff650E07),
                                          dotHeight: 6,
                                          dotWidth: 6,
                                          expansionFactor: 3,
                                          spacing: 5,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // "|| Jai Mata Di ||" with flanking decorative lines — first screen only
                                    if (index == 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 55,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/images/image 12.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "|| Jai Mata Di ||",
                                            style: TextStyle(
                                              color: Color(0xff9D1911),
                                              fontSize: 15,
                                              letterSpacing: 1.2,
                                              fontFamily: 'CormorantInfant',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 55,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/images/image 11.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),

                                    if (index == 0) const SizedBox(height: 22),
                                    if (index == 1 || index == 2)
                                      const SizedBox(height: 26),
                                    if (index == 3) const SizedBox(height: 12),

                                    // Optional header above main title
                                    if (item.header.isNotEmpty)
                                      Text(
                                        item.header,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff3D2B1F),
                                          fontFamily: 'AvenirNextCyr',
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),

                                    if (item.header.isNotEmpty)
                                      const SizedBox(height: 2),

                                    // Main title
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xffC42118),
                                              Color(0xff9D1911),
                                              Color(0xff650E07),
                                            ],
                                            stops: [0.0, 0.45, 1.0],
                                          ).createShader(bounds),
                                      blendMode: BlendMode.srcIn,
                                      child: Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: item.titleFontSize,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'CormorantInfant',
                                          height: 1.1,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Decorative divider
                                    Image.asset(item.group, height: 18),

                                    const SizedBox(height: 10),

                                    // Subtitle / description
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        item.subtitle,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff6B5244),
                                          height: 1.6,
                                          fontFamily: 'AvenirNextCyr',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // Feature chips (screens 2-4)
                                    if (item.features.isNotEmpty &&
                                        (icons.isNotEmpty ||
                                            _featureImages[index]
                                                .isNotEmpty)) ...[
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          item.features.length,
                                          (i) {
                                            return Column(
                                              children: [
                                                _featureImages[index].isNotEmpty
                                                    ? SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Image.asset(
                                                          _featureImages[index][i],
                                                          fit: BoxFit.contain,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                          color: _red
                                                              .withValues(
                                                                alpha: 0.08,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                14,
                                                              ),
                                                          border: Border.all(
                                                            color: _red
                                                                .withValues(
                                                                  alpha: 0.25,
                                                                ),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          icons[i],
                                                          color: _red,
                                                          size: 22,
                                                        ),
                                                      ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  item.features[i],
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xff5A3A2A),
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            // Next / Continue button
                            CustomButton(
                              title: item.buttonText,
                              onTap: _nextPage,
                            ),

                            SizedBox(height: size.height * 0.04),
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
