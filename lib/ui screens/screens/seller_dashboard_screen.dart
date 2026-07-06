import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/earnings_screen.dart';
import 'package:matabari/ui%20screens/screens/prasad_orders_screen.dart';
import 'package:matabari/ui%20screens/screens/profile_screen.dart';

/// Dashboard shown to a Prasad Seller after completing registration.
class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  int currentIndex = 0;
  String sellerName = "Seller Ji";

  static const _tabTitles = ["Dashboard", "Orders", "Earnings", "My Profile"];

  @override
  void initState() {
    super.initState();
    _loadSellerName();
  }

  Future<void> _loadSellerName() async {
    final name = await SessionPrefs.getUserName();
    if (!mounted || name == null || name.isEmpty) return;
    setState(() => sellerName = name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.background,
      body: SafeArea(
        top: currentIndex != 1 && currentIndex != 2,
        child: switch (currentIndex) {
          0 => _SellerHomeTab(name: sellerName),
          1 => PrasadOrdersScreen(
            onBack: () => setState(() => currentIndex = 0),
          ),
          2 => EarningsScreen(onBack: () => setState(() => currentIndex = 0)),
          3 => const ProfileScreen(),
          _ => _ComingSoonTab(title: _tabTitles[currentIndex]),
        },
      ),
      bottomNavigationBar: _SellerBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}

class _SellerHomeTab extends StatelessWidget {
  final String name;

  const _SellerHomeTab({required this.name});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 20),
          _statsCard(),
          const SizedBox(height: 22),
          Text("Today's Overview", style: _sectionTitleStyle),
          const SizedBox(height: 10),
          _overviewCard(),
          const SizedBox(height: 22),
          _orderStatusSection(),
          const SizedBox(height: 22),
          _topSellingSection(),
          const SizedBox(height: 22),
          _recentOrdersSection(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  static TextStyle get _sectionTitleStyle => cormorantInfantBold.copyWith(
    color: ColorResources.textDark,
    fontSize: 14,
  );

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorResources.cardBg,
            shape: BoxShape.circle,
            border: Border.all(color: ColorResources.border),
          ),
          child: const Icon(
            Icons.person,
            color: ColorResources.textDark,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jai Maa Tripura Sundari",
                style: avenirNextCyr.copyWith(
                  color: const Color(0xffA61D2A),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Welcome, $name",
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Image.asset('assets/images/Group 43.png', width: 34, height: 34),
      ],
    );
  }

  Widget _statsCard() {
    const stats = [
      (
        "assets/images/Shopping bag (1).png",
        "Orders Today",
        "24",
        "New Order",
        "08",
      ),
      (
        "assets/images/Truck.png",
        "Orders in Progress",
        "10",
        "Ready to Deliver",
        "06",
      ),
      (
        "assets/images/Package.png",
        "Delivered Today",
        "08",
        "Total Order",
        "142",
      ),
      (
        "assets/images/₹.png",
        "Revenue Today",
        "₹12.5K",
        "This Week",
        "₹78.45K",
      ),
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i != 0) const SizedBox(width: 8),
            _statTile(stats[i]),
          ],
        ],
      ),
    );
  }

  Widget _statTile((String, String, String, String, String) stat) {
    final (icon, label, value, subLabel, subValue) = stat;
    return Container(
      width: 86,
      height: 139,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE6C8),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(icon, width: 16, height: 16),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textLight,
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: avenirNextCyr.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Image.asset('assets/images/Line 12.png', width: 50, height: 1),
              const SizedBox(height: 4),
              Text(
                subLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: avenirNextCyr.copyWith(
                  color: const Color(0xFF484C52),
                  fontSize: 6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: avenirNextCyr.copyWith(
                  color: const Color(0xFF4B703C),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _sparklineColor = Color(0xffE8963D);
  static const _xAxisLabels = ["12 AM", "12 PM", "12 AM"];

  Widget _overviewDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: RotatedBox(
        quarterTurns: 1,
        child: Image.asset('assets/images/Line 12.png', width: 56, height: 1),
      ),
    );
  }

  Widget _overviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Revenue",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 7,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹12.5K",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF4B703C),
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/Chevrons up.png',
                        width: 9,
                        height: 9,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        "18% vs yesterday",
                        style: avenirNextCyr.copyWith(
                          color: const Color(0xFF4B703C),
                          fontSize: 7,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _overviewDivider(),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SparklinePainter(const [
                      4,
                      6,
                      5,
                      8,
                      7,
                      9,
                      8,
                      11,
                      10,
                      12.5,
                    ], _sparklineColor),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(_xAxisLabels.length, (i) {
                    final align = i == 0
                        ? TextAlign.left
                        : i == _xAxisLabels.length - 1
                        ? TextAlign.right
                        : TextAlign.center;
                    return Expanded(
                      child: Text(
                        _xAxisLabels[i],
                        textAlign: align,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        style: avenirNextCyr.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 6,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          _overviewDivider(),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Average Order Value",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 7,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹521",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Item Sold: 186",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderStatusSection() {
    const statuses = [
      ("assets/images/Shopping bag (1).png", "08", "New Orders"),
      ("assets/images/Cooking.png", "10", "Preparing"),
      ("assets/images/Truck.png", "06", "Out for Delivery"),
      ("assets/images/Check circle.png", "08", "Delivered"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Order Status Overview", style: _sectionTitleStyle),
            Text(
              "View All Orders",
              style: avenirNextCyr.copyWith(
                color: ColorResources.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < statuses.length; i++) ...[
                if (i != 0)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: ColorResources.textLight,
                      size: 26,
                    ),
                  ),
                Expanded(child: _orderStatusItem(statuses[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _orderStatusItem((String, String, String) status) {
    final (icon, value, label) = status;
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFFBE6C8),
            shape: BoxShape.circle,
          ),
          child: Image.asset(icon, width: 16, height: 16),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: avenirNextCyr.copyWith(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: avenirNextCyr.copyWith(
            color: ColorResources.textLight,
            fontSize: 8,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _topSellingSection() {
    const items = [
      (
        "Coconut (Nariyal)",
        "320 Items",
        "₹16,000",
        "assets/images/Rectangle 909.png",
        null,
      ),
      (
        "Chunri",
        "250 Items",
        "₹15,000",
        "assets/images/Rectangle 911.png",
        null,
      ),
      (
        "Bhog / Prasad",
        "210 Items",
        "₹10,500",
        "assets/images/Rectangle 914.png",
        null,
      ),
      (
        "Deepdaan",
        "180 Items",
        "₹7,200",
        "assets/images/Rectangle 915.png",
        null,
      ),
      (
        "Flowers",
        "150 Items",
        "₹4,800",
        "assets/images/Rectangle 918.png",
        null,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Top Selling Prasad", style: _sectionTitleStyle),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: items
                  .map(
                    (item) =>
                        SizedBox(width: itemWidth, child: _topSellingCard(item)),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _topSellingCard(
    (String, String, String, String?, IconData?) item,
  ) {
    final (name, sold, price, image, icon) = item;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: image != null
                ? Image.asset(
                    image,
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 38,
                    height: 38,
                    color: const Color(0xFFFBE6C8),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: ColorResources.kOrange,
                      size: 18,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  sold,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  price,
                  style: avenirNextCyr.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentOrdersSection() {
    const orders = [
      ("#PS1254", "Coconut, Chunri, Bhog", "09:30 AM", "Preparing"),
      ("#PS1253", "Coconut, Deepdaan", "09:15 AM", "Now"),
      ("#PS1252", "Chunri, Bhog", "08:45 AM", "Preparing"),
      ("#PS1251", "Coconut, Flower, Bhog", "08:20 AM", "Out for Delivery"),
      ("#PS1250", "Deepdaan, Chunri", "07:50 AM", "Delivered"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Orders", style: _sectionTitleStyle),
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
                const Icon(
                  Icons.chevron_right_rounded,
                  color: ColorResources.primary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
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
              for (var i = 0; i < orders.length; i++) ...[
                if (i != 0)
                  Image.asset(
                    'assets/images/Line 12.png',
                    width: double.infinity,
                    height: 1,
                    fit: BoxFit.fill,
                  ),
                _recentOrderRow(orders[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _recentOrderRow((String, String, String, String) order) {
    final (id, items, time, status) = order;
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
                Text(
                  items,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textLight,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6),
              _statusPill(status),
            ],
          ),
        ],
      ),
    );
  }

  static const _statusStyles = {
    "Preparing": (Color(0xFF4B703C), Colors.white),
    "Now": (Color(0xFFFCE7CA), Color(0xFFB45309)),
    "Out for Delivery": (Color(0xFFDBEAFE), Color(0xFF2563EB)),
    "Delivered": (Color(0xFF4B703C), Colors.white),
  };

  Widget _statusPill(String status) {
    final (bg, fg) = _statusStyles[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: avenirNextCyr.copyWith(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Draws the small revenue trend line on the overview card without
/// depending on a charting package.
class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  /// Fraction of the canvas height the line swings across; lower values
  /// flatten the slope.
  static const double amplitude = 0.55;

  _SparklinePainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final maxV = points.reduce((a, b) => a > b ? a : b);
    final minV = points.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV) == 0 ? 1 : maxV - minV;
    final dx = size.width / (points.length - 1);
    final midY = size.height / 2;

    final linePath = Path();
    final fillPath = Path();
    final offsets = <Offset>[];

    for (var i = 0; i < points.length; i++) {
      final x = dx * i;
      final normalized = (points[i] - minV) / range;
      final y = midY - (normalized - 0.5) * size.height * amplitude;
      offsets.add(Offset(x, y));

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: .12)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    final dotPaint = Paint()..color = color;
    for (final offset in offsets) {
      canvas.drawCircle(offset, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}

class _ComingSoonTab extends StatelessWidget {
  final String title;

  const _ComingSoonTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$title — coming soon",
        style: avenirNextCyr.copyWith(
          color: ColorResources.textLight,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SellerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _SellerBottomNav({required this.currentIndex, required this.onTap});

  static const _items = ["Dashboard", "Orders", "Earnings", "My Profile"];

  static const _icons = [
    "assets/images/Layout.png",
    "assets/images/Group 47.png",
    "assets/images/Icon.png",
    "assets/images/Avatar.png",
  ];

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
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          color,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          _icons[i],
                          width: 22,
                          height: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _items[i],
                        style: avenirNextCyr.copyWith(
                          color: color,
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
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
