import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/style.dart';

/// Product-wise sales breakdown and recent settlement payments, shown
/// beneath the earnings summary on the seller dashboard's "Earnings" tab.
class ProductWiseSaleSection extends StatelessWidget {
  const ProductWiseSaleSection({super.key});

  static const _products = [
    ("Coconut (Nariyal)", "assets/images/Rectangle 909.png", "610 Orders", "₹28,500"),
    ("Chunri", "assets/images/Rectangle 911.png", "320 Orders", "₹22,400"),
    ("Bhog / Prasad", "assets/images/Rectangle 914.png", "210 Orders", "₹15,750"),
    ("Deepdaan", "assets/images/Rectangle 915.png", "180 Orders", "₹8,100"),
    ("Flowers", "assets/images/Rectangle 918.png", "125 Orders", "₹4,700"),
  ];

  static const _payments = [
    ("#PS1254", "Coconut, Bhog", "09:30 AM", "Paid"),
    ("#PS1253", "Coconut, Deepdaan", "09:15 AM", "Pending"),
    ("#PS1252", "Chunri, Bhog", "08:45 AM", "Paid"),
    ("#PS1251", "Coconut, Flower, Bhog", "08:20 AM", "Paid"),
    ("#PS1250", "Deepdaan, Chunri", "07:50 AM", "Pending"),
  ];

  static const _statusStyles = {
    "Paid": (Color(0xFF4B703C), Colors.white),
    "Pending": (Color(0xFFFCE7CA), Color(0xFFB45309)),
  };

  static const _filters = [
    (Icons.calendar_today_outlined, "Date"),
    (Icons.category_outlined, "Puja Type"),
    (Icons.verified_outlined, "Settlement Status"),
    (Icons.sort_rounded, "Sort"),
  ];

  static TextStyle get _sectionTitleStyle =>
      cormorantInfantBold.copyWith(color: ColorResources.textDark, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Product Wise Sale", style: _sectionTitleStyle),
            _downloadReportButton(),
          ],
        ),
        const SizedBox(height: 10),
        _filterRow(),
        const SizedBox(height: 14),
        _productListCard(),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Payments", style: _sectionTitleStyle),
            Row(
              children: [
                Text(
                  "View All",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: ColorResources.primary, size: 16),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        _paymentsCard(),
      ],
    );
  }

  Widget _downloadReportButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: ColorResources.kOrange, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.file_download_outlined, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            "Download Report",
            style: avenirNextCyr.copyWith(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _filterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _filters.length; i++) ...[
            if (i != 0) const SizedBox(width: 8),
            _filterChip(_filters[i].$1, _filters[i].$2),
          ],
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
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: ColorResources.textLight),
        ],
      ),
    );
  }

  Widget _cardWrap(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
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
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i != 0)
              Image.asset('assets/images/Line 12.png', width: double.infinity, height: 1, fit: BoxFit.fill),
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _productListCard() {
    return _cardWrap([for (final product in _products) _productRow(product)]);
  }

  Widget _productRow((String, String, String, String) product) {
    final (name, image, orders, amount) = product;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        children: [
          ClipOval(child: Image.asset(image, width: 42, height: 42, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(orders, style: avenirNextCyr.copyWith(color: ColorResources.textLight, fontSize: 10)),
              ],
            ),
          ),
          Text(
            amount,
            style: avenirNextCyr.copyWith(color: ColorResources.primary, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _paymentsCard() {
    return _cardWrap([for (final payment in _payments) _paymentRow(payment)]);
  }

  Widget _paymentRow((String, String, String, String) payment) {
    final (id, items, time, status) = payment;
    final (badgeBg, badgeFg) = _statusStyles[status]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(items, style: avenirNextCyr.copyWith(color: ColorResources.textLight, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: avenirNextCyr.copyWith(color: ColorResources.textLight, fontSize: 10)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  status,
                  style: avenirNextCyr.copyWith(color: badgeFg, fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
