import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matabari/config/utils/onboarding_prefs.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/ui%20screens/authscreen/onboarding_screen.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/dashbboard_screen.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/pandit_dashboard_screen.dart';
import 'package:matabari/ui%20screens/screens/prasad_seller/seller_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () async {
      // A previously saved session takes the user straight back to their
      // dashboard — no onboarding, no login — until they log out or the
      // app is uninstalled.
      final loggedIn = await SessionPrefs.isLoggedIn();
      if (loggedIn) {
        final role = await SessionPrefs.getRole();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => switch (role) {
              'seller' => const SellerDashboardScreen(),
              'pandit' => const PanditDashboardScreen(),
              _ => const DashboardScreen(),
            },
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
        return;
      }

      // Show onboarding only on the first launch; afterwards go straight
      // to the mobile-number (login) screen.
      final seenOnboarding = await OnboardingPrefs.hasSeen();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => seenOnboarding
              ? const AuthLoginScreen()
              : const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECD5),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox.expand(
                child: Image.asset(
                  "assets/images/splash_screen.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
