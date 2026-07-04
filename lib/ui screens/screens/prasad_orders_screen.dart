import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/style.dart';

/// Order management page shown under the seller dashboard's "Orders" tab.
class PrasadOrdersScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const PrasadOrdersScreen({super.key, this.onBack});

  @override
  State<PrasadOrdersScreen> createState() => _PrasadOrdersScreenState();
}

class _PrasadOrdersScreenState extends State<PrasadOrdersScreen> {
  int _selectedTab = 0;

  static const _tabs = [
    ("New Orders", "08"),
    ("Preparing", "10"),
    ("Out for Delivery", "06"),
    ("Delivered", "08"),
    ("Cancelled", "02"),
  ];

  static const _orders = [
    (
      "#PS1254",
      "New",
      "Mata Tripura Sundari Puja",
      "25 Jun 2026 · 07:00 AM",
      "Rahul Sharma",
      5,
      [("Coconut", "×2"), ("Chunri", "×1"), ("Bhog Prasad", "×1")],
      1,
      "₹451",
    ),
    (
      "#PS1253",
      "Preparing",
      "Mata Tripura Sundari Puja",
      "25 Jun 2026 · 06:30 AM",
      "Priya Sharma",
      4,
      [("Coconut", "×1"), ("Deepdaan", "×2")],
      1,
      "₹651",
    ),
    (
      "#PS1252",
      "Preparing",
      "Mata Tripura Sundari Puja",
      "24 Jun 2026 · 05:00 PM",
      "Anita Rao",
      2,
      [("Chunri", "×1"), ("Bhog Prasad", "×1")],
      0,
      "₹351",
    ),
    (
      "#PS1251",
      "Out for Delivery",
      "Mata Tripura Sundari Puja",
      "24 Jun 2026 · 04:30 PM",
      "Vikram Singh",
      3,
      [("Coconut", "×1"), ("Flower", "×1"), ("Bhog Prasad", "×1")],
      0,
      "₹551",
    ),
    (
      "#PS1250",
      "Delivered",
      "Mata Tripura Sundari Puja",
      "23 Jun 2026 · 08:00 PM",
      "Sunita Joshi",
      2,
      [("Deepdaan", "×1"), ("Chunri", "×1")],
      0,
      "₹301",
    ),
  ];

  static const _statusStyles = {
    "New": (Color(0xFFFCE7CA), Color(0xFFB45309)),
    "Preparing": (Color(0xFF4B703C), Colors.white),
    "Out for Delivery": (Color(0xFFDBEAFE), Color(0xFF2563EB)),
    "Delivered": (Color(0xFF4B703C), Colors.white),
  };

  static const _itemImages = {
    "Coconut": "assets/images/Rectangle 909.png",
    "Chunri": "assets/images/Rectangle 911.png",
    "Bhog Prasad": "assets/images/Rectangle 914.png",
    "Deepdaan": "assets/images/Rectangle 915.png",
    "Flower": "assets/images/Rectangle 918.png",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const overlap = 22.0;
              return Transform.translate(
                offset: const Offset(0, -overlap),
                child: SizedBox(
                  height: constraints.maxHeight + overlap,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: ColorResources.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: overlap + 14),
                        _filterRow(),
                        const SizedBox(height: 18),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                            itemCount: _orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) =>
                                _orderCard(_orders[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Group 31.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                _circleIconButton(
                  Icons.arrow_back_ios_new_rounded,
                  widget.onBack,
                ),
                Expanded(
                  child: Text(
                    "Prasad Orders",
                    textAlign: TextAlign.center,
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                _circleIconButton(Icons.tune_rounded, () {}),
              ],
            ),
            const SizedBox(height: 14),
            _tabBar(),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.18),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (i) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _tabChip(i),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabChip(int index) {
    final (label, count) = _tabs[index];
    final selected = index == _selectedTab;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7A1712) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Badge(
          backgroundColor: ColorResources.kOrange,
          offset: const Offset(0, -10),
          padding: const EdgeInsets.symmetric(horizontal: 3),
          label: Text(
            count,
            style: const TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: avenirNextCyr.copyWith(
              color: selected ? Colors.white : ColorResources.textDark,
              fontSize: 9,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _filterChip(Icons.sort_rounded, "Date: Latest First"),
          _filterChip(Icons.filter_alt_outlined, "All Puja Types"),
        ],
      ),
    );
  }

  Widget _filterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorResources.cardBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: ColorResources.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ColorResources.textLight),
          const SizedBox(width: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textDark,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 14,
            color: ColorResources.textLight,
          ),
        ],
      ),
    );
  }

  Widget _orderCard(
    (
      String,
      String,
      String,
      String,
      String,
      int,
      List<(String, String)>,
      int,
      String,
    )
    order,
  ) {
    final (
      id,
      status,
      puja,
      dateTime,
      customer,
      totalItems,
      items,
      more,
      price,
    ) = order;
    final (badgeBg, badgeFg) = _statusStyles[status]!;
    final thumbnail = _itemImages[items.first.$1] ?? _itemImages["Coconut"]!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorResources.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorResources.border, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: ColorResources.secondary.withValues(alpha: 0.45),
            blurRadius: 8,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  thumbnail,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "Order $id",
                            overflow: TextOverflow.ellipsis,
                            style: avenirNextCyr.copyWith(
                              color: ColorResources.textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.copy_rounded,
                          size: 12,
                          color: ColorResources.textLight,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: avenirNextCyr.copyWith(
                                  color: badgeFg,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "$totalItems items",
                              style: avenirNextCyr.copyWith(
                                color: ColorResources.textLight,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: ColorResources.textLight,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            puja,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: avenirNextCyr.copyWith(
                              color: ColorResources.textLight,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 10,
                          color: ColorResources.textLight,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            dateTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: avenirNextCyr.copyWith(
                              color: ColorResources.textLight,
                              fontSize: 8.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 10,
                                color: ColorResources.textLight,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: avenirNextCyr.copyWith(
                                    color: ColorResources.textLight,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          price,
                          style: avenirNextCyr.copyWith(
                            color: ColorResources.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/Line 12.png',
            width: double.infinity,
            height: 1,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final (name, qty) in items) _itemChip(name, qty),
                    if (more > 0)
                      Text(
                        "+$more more",
                        style: avenirNextCyr.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _actionButton(status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemChip(String name, String qty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE6C8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              _itemImages[name] ?? _itemImages["Coconut"]!,
              width: 14,
              height: 14,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "$name $qty",
            style: avenirNextCyr.copyWith(
              color: ColorResources.textDark,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String status) {
    final isDelivered = status == "Delivered";
    final label = status == "New"
        ? "Accept Order"
        : isDelivered
        ? "View Details"
        : "Update Status";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDelivered ? const Color(0xFFE8F3E4) : ColorResources.kOrange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: avenirNextCyr.copyWith(
          color: isDelivered ? const Color(0xFF4B703C) : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
