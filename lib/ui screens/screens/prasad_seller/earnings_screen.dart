import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/prasad_seller/product_wise_sale_screen.dart';

/// Earnings & settlement summary shown under the seller dashboard's
/// "Earnings" tab.
class EarningsScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const EarningsScreen({super.key, this.onBack});

  static const _summaryStats = [
    (
      "Total Earnings",
      "₹1,25,000",
      "All Time",
      ColorResources.textLight,
      'assets/images/₹.png',
    ),
    (
      "Settled Amount",
      "₹90,000",
      "Settled by Admin",
      Color(0xFF4B703C),
      'assets/images/Check circle.png',
    ),
    (
      "Pending Settlement",
      "₹35,000",
      "Pending Amount",
      ColorResources.kOrange,
      'assets/images/image 41.png',
    ),
  ];

  static const _overviewStats = [
    ("Total Orders", "380", 'assets/images/Shopping bag (1).png'),
    ("Total Order Value", "₹52,450", 'assets/images/Package.png'),
    ("Amount Settled", "₹37,800", 'assets/images/Check circle.png'),
    ("Pending Amount", "₹14,650", 'assets/images/image 41.png'),
  ];

  static const _trendPoints = <double>[
    300,
    900,
    1000,
    700,
    1600,
    2200,
    1750,
    1500,
    2900,
    2900,
    2900,
    3600,
    4200,
    3300,
    4200,
    6900,
    8050,
    5600,
    6900,
    4300,
    7150,
    3000,
    5300,
    4500,
    6000,
    7300,
    5900,
    7250,
    6300,
    7250,
    5500,
  ];
  static const _trendXLabels = [
    "01 May",
    "05 May",
    "10 May",
    "15 May",
    "20 May",
    "25 May",
    "31 May",
  ];
  static const _trendXLabelIndices = [0, 4, 9, 14, 19, 24, 30];
  static const _trendMaxScale = 10000.0;
  static const _trendPeakDate = "17 May 2026";

  static const _settlementLegend = [
    ("Paid", "₹37,800", "72%", Color(0xFF4B703C)),
    ("Pending", "₹14,650", "28%", ColorResources.kOrange),
  ];

  static TextStyle get _sectionTitleStyle => cormorantInfantBold.copyWith(
    color: ColorResources.textDark,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(context),
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(18, overlap + 18, 18, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _summaryRow(),
                          const SizedBox(height: 22),
                          _sectionHeader(
                            "Earnings Overview",
                            pillLabel: "This Month",
                            filled: true,
                          ),
                          const SizedBox(height: 10),
                          _overviewCard(),
                          const SizedBox(height: 22),
                          _sectionHeader(
                            "Earnings Trend",
                            pillLabel: "Daily",
                            filled: true,
                          ),
                          const SizedBox(height: 10),
                          _trendCard(),
                          const SizedBox(height: 22),
                          Text("Settlement Status", style: _sectionTitleStyle),
                          const SizedBox(height: 10),
                          _settlementRow(),
                          const SizedBox(height: 22),
                          const ProductWiseSaleSection(),
                        ],
                      ),
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

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 34),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Group 31.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _circleIconButton(Icons.arrow_back_ios_new_rounded, onBack),
            Expanded(
              child: Text(
                "Earnings",
                textAlign: TextAlign.center,
                style: cormorantInfantBold.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
            _circleImageButton('assets/images/Calendar.png', () {}),
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

  Widget _circleImageButton(String asset, VoidCallback? onTap) {
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
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          child: Image.asset(asset, width: 16, height: 16),
        ),
      ),
    );
  }

  Widget _cardDecoration({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double radius = 20,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorResources.cardBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: ColorResources.border, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: ColorResources.secondary.withValues(alpha: 0.45),
            blurRadius: 8,
            spreadRadius: -1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _summaryRow() {
    return Row(
      children: [
        for (var i = 0; i < _summaryStats.length; i++) ...[
          if (i != 0) const SizedBox(width: 10),
          Expanded(child: _summaryCard(_summaryStats[i])),
        ],
      ],
    );
  }

  Widget _summaryCard((String, String, String, Color, String) stat) {
    final (label, value, sub, subColor, icon) = stat;
    return _cardDecoration(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorResources.kOrange.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Image.asset(icon, width: 16, height: 16),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textLight,
              fontSize: 9,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: avenirNextCyr.copyWith(
              color: subColor,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    String title, {
    required String pillLabel,
    required bool filled,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: _sectionTitleStyle),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: filled ? ColorResources.primary : Colors.transparent,
            border: filled ? null : Border.all(color: ColorResources.border),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            pillLabel,
            style: avenirNextCyr.copyWith(
              color: filled ? Colors.white : ColorResources.textDark,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _thinDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RotatedBox(
        quarterTurns: 1,
        child: Image.asset('assets/images/Line 12.png', width: 44, height: 1),
      ),
    );
  }

  Widget _overviewCard() {
    return _cardDecoration(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Row(
        children: [
          for (var i = 0; i < _overviewStats.length; i++) ...[
            if (i != 0) _thinDivider(),
            Expanded(child: _overviewStatItem(_overviewStats[i])),
          ],
        ],
      ),
    );
  }

  Widget _overviewStatItem((String, String, String) stat) {
    final (label, value, icon) = stat;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorResources.kOrange.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Image.asset(icon, width: 16, height: 16),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: avenirNextCyr.copyWith(
            color: ColorResources.textLight,
            fontSize: 8,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: avenirNextCyr.copyWith(
            color: ColorResources.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _trendCard() {
    return _cardDecoration(
      child: _TrendChart(
        points: _trendPoints,
        maxScale: _trendMaxScale,
        xLabels: _trendXLabels,
        xLabelIndices: _trendXLabelIndices,
        peakDate: _trendPeakDate,
        peakValue: "₹8,050",
      ),
    );
  }

  Widget _settlementRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 248,
          child: SizedBox(height: 120, child: _settlementCard()),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 119,
          child: SizedBox(height: 120, child: _nextSettlementCard()),
        ),
      ],
    );
  }

  Widget _settlementCard() {
    return _cardDecoration(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(84, 84),
                  painter: const _DonutPainter(
                    paidFraction: 0.72,
                    paidColor: Color(0xFF4B703C),
                    pendingColor: ColorResources.kOrange,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹52,450",
                      style: avenirNextCyr.copyWith(
                        color: ColorResources.textDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Total",
                      style: avenirNextCyr.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final item in _settlementLegend) _legendRow(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendRow((String, String, String, Color) item) {
    final (label, value, pct, color) = item;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: avenirNextCyr.copyWith(
                color: ColorResources.textDark,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "($pct)",
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textLight,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nextSettlementCard() {
    return _cardDecoration(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Next Settlement",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE6C8),
                  shape: BoxShape.circle,
                ),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    ColorResources.kOrange,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/images/₹.png',
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "01 JUN 2026",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: avenirNextCyr.copyWith(
              color: ColorResources.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Estimated Settlement Date",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textLight,
              fontSize: 8,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the seller's daily earnings line with a peak-value tooltip,
/// a ₹-scale Y axis and dated X axis, matching the design mock exactly.
class _TrendChart extends StatelessWidget {
  final List<double> points;
  final double maxScale;
  final List<String> xLabels;
  final List<int> xLabelIndices;
  final String peakDate;
  final String peakValue;

  static const _color = Color(0xffE8963D);
  static const _chartHeight = 190.0;
  static const _yAxisWidth = 30.0;
  static const _topGap = 44.0;

  const _TrendChart({
    required this.points,
    required this.maxScale,
    required this.xLabels,
    required this.xLabelIndices,
    required this.peakDate,
    required this.peakValue,
  });

  static String _formatK(double v) {
    if (v == 0) return "₹0";
    return "₹${(v / 1000).toStringAsFixed(0)}K";
  }

  @override
  Widget build(BuildContext context) {
    final maxV = points.reduce((a, b) => a > b ? a : b);
    final peakIndex = points.indexOf(maxV);
    final yAxisLabels = List.generate(
      6,
      (i) => _formatK(maxScale - (maxScale / 5) * i),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final plotWidth = constraints.maxWidth - _yAxisWidth - 6;
        final dx = plotWidth / (points.length - 1);
        final peakY =
            _chartHeight - (points[peakIndex] / maxScale) * _chartHeight;
        final peakX = dx * peakIndex;

        const totalHeight = _chartHeight + _topGap;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: totalHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: _yAxisWidth,
                    height: totalHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: _topGap),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (final label in yAxisLabels)
                            Text(
                              label,
                              style: avenirNextCyr.copyWith(
                                color: ColorResources.textLight,
                                fontSize: 8,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SizedBox(
                      height: totalHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            top: _topGap,
                            child: CustomPaint(
                              size: Size(plotWidth, _chartHeight),
                              painter: _TrendPainter(points, maxScale, _color),
                            ),
                          ),
                          Positioned(
                            left: (peakX - 34).clamp(0, plotWidth - 68),
                            top: (_topGap + peakY - 60).clamp(
                              0,
                              totalHeight - 34,
                            ),
                            child: _tooltip(peakDate, peakValue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const SizedBox(width: _yAxisWidth + 6),
                Expanded(child: _xAxisLabels(plotWidth)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _xAxisLabels(double plotWidth) {
    final style = avenirNextCyr.copyWith(
      color: ColorResources.textLight,
      fontSize: 8,
    );
    final widths = xLabels.map((label) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      return painter.width;
    }).toList();

    const minGap = 4.0;
    final lefts = List<double>.filled(xLabels.length, 0);
    for (var i = 0; i < xLabels.length; i++) {
      final fraction = xLabelIndices[i] / (points.length - 1);
      double left;
      if (i == 0) {
        left = 0;
      } else if (i == xLabels.length - 1) {
        left = plotWidth - widths[i];
      } else {
        left = plotWidth * fraction - widths[i] / 2;
      }
      if (i > 0) {
        final minLeft = lefts[i - 1] + widths[i - 1] + minGap;
        if (left < minLeft) left = minLeft;
      }
      lefts[i] = left;
    }

    return SizedBox(
      width: plotWidth,
      height: 12,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(xLabels.length, (i) {
          return Positioned(
            left: lefts[i],
            child: Text(xLabels[i], style: style),
          );
        }),
      ),
    );
  }

  Widget _tooltip(String date, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorResources.border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            date,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textLight,
              fontSize: 9,
            ),
          ),
          Text(
            value,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<double> points;
  final double maxScale;
  final Color color;

  _TrendPainter(this.points, this.maxScale, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final dx = size.width / (points.length - 1);

    final linePath = Path();
    final fillPath = Path();
    final offsets = <Offset>[];

    for (var i = 0; i < points.length; i++) {
      final x = dx * i;
      final y = size.height - (points[i] / maxScale) * size.height;
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

    final axisPaint = Paint()
      ..color = ColorResources.border
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .35), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final dotPaint = Paint()..color = color;
    for (final offset in offsets) {
      canvas.drawCircle(offset, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.maxScale != maxScale ||
      oldDelegate.color != color;
}

/// Draws the paid vs. pending settlement ring in the Settlement Status card.
class _DonutPainter extends CustomPainter {
  final double paidFraction;
  final Color paidColor;
  final Color pendingColor;

  const _DonutPainter({
    required this.paidFraction,
    required this.paidColor,
    required this.pendingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.16;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    const start = -pi / 2;
    final paidSweep = 2 * pi * paidFraction;

    canvas.drawArc(
      rect,
      start,
      paidSweep,
      false,
      Paint()
        ..color = paidColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      rect,
      start + paidSweep,
      2 * pi - paidSweep,
      false,
      Paint()
        ..color = pendingColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.paidFraction != paidFraction;
}
