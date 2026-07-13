import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/style.dart';

/// Bottom navigation bar shared by every Pandit Ji screen (the dashboard
/// tabs plus any screen pushed on top of them), so it stays visible and
/// consistent regardless of how deep the user has navigated.
class PanditBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PanditBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = ["Dashboard", "Bookings", "Earning", "My Profile"];

  static const _icons = [
    "assets/images/Layout.png",
    "assets/images/calendar (1).png",
    "assets/images/₹.png",
    "assets/images/Avatar.png",
  ];

  /// ₹.png has much more internal padding than the other three (which are
  /// bold, edge-to-edge glyphs), so it's sized up slightly to keep all four
  /// visually consistent.
  static const _iconSizes = [18.0, 18.0, 22.0, 18.0];

  static const _selectedColor = ColorResources.kOrange;
  static const _unselectedColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              final color = selected ? _selectedColor : _unselectedColor;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 22,
                        width: 22,
                        child: Center(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                            child: Image.asset(
                              _icons[i],
                              width: _iconSizes[i],
                              height: _iconSizes[i],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _items[i],
                        style: avenirNextCyr.copyWith(
                          color: color,
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
