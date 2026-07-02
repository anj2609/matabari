import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Frosted-glass "Skip" pill used on the onboarding screens. Shared so every
/// screen with a skip action looks identical.
class SkipButton extends StatelessWidget {
  final VoidCallback onTap;

  const SkipButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white.withValues(alpha: 0.10),
              Colors.white.withValues(alpha: 0.10),
              Colors.white,
            ],
            stops: const [0.0, 0.35, 0.65, 1.0],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20.8),
              ),
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
