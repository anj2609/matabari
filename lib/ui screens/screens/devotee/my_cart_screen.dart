import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  static const int _convenienceFee = 99;

  Map<String, dynamic>? selectedPuja = {
    "title": "Maa Tripura Sundari Puja",
    "sub": "Maa Tripura Sundari Puja",
    "date": "26 Jun 2026",
    "family": "Family (4 Members)",
    "price": 499,
    "image": "assets/images/Rectangle 693.png",
  };

  final List<Map<String, dynamic>> offerings = [
    {
      "title": "Coconut",
      "sub": "Symbol of purity & devotion",
      "price": 51,
      "image": "assets/images/Rectangle 666.png",
      "qty": 1,
    },
    {
      "title": "Chunri",
      "sub": "Offer your devotion to Maa",
      "price": 101,
      "image": "assets/images/Rectangle 673.png",
      "qty": 1,
    },
    {
      "title": "Deepdaan",
      "sub": "Light of devotion & positivity",
      "price": 51,
      "image": "assets/images/Rectangle 788.png",
      "qty": 1,
    },
    {
      "title": "Prasad Box",
      "sub": "Blessed prasad for you & family",
      "price": 499,
      "image": "assets/images/prasad.png",
      "qty": 1,
    },
  ];

  int get _pujaBasePrice => (selectedPuja?['price'] as int?) ?? 0;

  int get _chadhavaTotal => offerings.fold(
    0,
    (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
  );

  int get _totalAmount => _pujaBasePrice + _chadhavaTotal + _convenienceFee;

  int get _offeringCount => offerings.where((o) => (o['qty'] as int) > 0).length;

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  Future<void> _confirmClearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Clear Cart",
          style: cormorantInfantBold.copyWith(color: ColorResources.blackColor, fontSize: 18),
        ),
        content: Text(
          "Remove the selected puja and all offerings from your cart?",
          style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              "Cancel",
              style: avenirNextCyr.copyWith(color: ColorResources.blackColor, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              "Clear",
              style: avenirNextCyr.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    setState(() {
      selectedPuja = null;
      for (final item in offerings) {
        item['qty'] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Group 31.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .2),
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "My Cart",
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.spacingSize22,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Review your selected offerings",
                                  style: avenirNextRegular.copyWith(
                                    color: Colors.white70,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _confirmClearCart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .18),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.delete_outline, color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Clear Cart",
                                    style: avenirNextCyr.copyWith(color: Colors.white, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// BODY
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffF8F5F0),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          "Selected Puja",
                          trailing: selectedPuja == null
                              ? null
                              : GestureDetector(
                                  onTap: () => setState(() => selectedPuja = null),
                                  child: Text(
                                    "Delete",
                                    style: avenirNextCyr.copyWith(
                                      color: const Color(0xFFE07A00),
                                      fontSize: Dimensions.fontSizeDefault,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        if (selectedPuja != null)
                          _pujaCard(selectedPuja!)
                        else
                          _emptyRow("No puja selected"),
                        const SizedBox(height: 20),

                        _sectionHeader(
                          "Your Offerings ($_offeringCount)",
                          trailing: GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Add More",
                                  style: avenirNextCyr.copyWith(
                                    color: const Color(0xFFE07A00),
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                ),
                                const Icon(Icons.add, size: 16, color: Color(0xFFE07A00)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_offeringCount == 0)
                          _emptyRow("No offerings added")
                        else
                          ...offerings.map(_offeringRow),
                        const SizedBox(height: 20),

                        _priceDetails(),
                        const SizedBox(height: 14),
                        _trustFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _gradientText(
            title,
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
          ),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _emptyRow(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Text(
          message,
          style: avenirNextRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ),
    );
  }

  /// ---------------- SELECTED PUJA CARD ----------------
  Widget _pujaCard(Map<String, dynamic> puja) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                puja['image'] as String,
                height: 68,
                width: 68,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          puja['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _notify("Editing ${puja['title']}"),
                        child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xff9D1911)),
                      ),
                    ],
                  ),
                  Text(
                    puja['sub'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        puja['date'] as String,
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.people_alt_outlined, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        puja['family'] as String,
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${puja['price']}/-",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.kOrange,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- OFFERING ROW ----------------
  Widget _offeringRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item['image'] as String,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize14,
                    ),
                  ),
                  Text(
                    item['sub'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _offeringQtyControl(item),
                const SizedBox(height: 4),
                Text(
                  "₹${item['price']}/-",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.kOrange,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _offeringQtyControl(Map<String, dynamic> item) {
    final qty = item['qty'] as int;

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE07A00),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              item['qty'] = qty > 0 ? qty - 1 : 0;
            }),
            child: const Icon(Icons.remove, color: Colors.white, size: 13),
          ),
          SizedBox(
            width: 18,
            child: Text(
              "$qty",
              textAlign: TextAlign.center,
              style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => item['qty'] = qty + 1),
            child: const Icon(Icons.add, color: Colors.white, size: 13),
          ),
        ],
      ),
    );
  }

  /// ---------------- PRICE DETAILS ----------------
  Widget _priceDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientText(
              "Price Details",
              cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
            ),
            const SizedBox(height: 10),
            _priceRow("Puja Base Price", _pujaBasePrice),
            _priceRow("Selected Chadhava", _chadhavaTotal),
            _priceRow("Convenience Fee", _convenienceFee),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: Color(0xffF3D8B3)),
            ),
            _priceRow("Total Amount", _totalAmount, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, int amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (bold ? cormorantInfantBold : avenirNextRegular).copyWith(
              color: ColorResources.blackColor,
              fontSize: bold ? Dimensions.spacingSize16 : Dimensions.fontSizeDefault,
            ),
          ),
          Text(
            "₹$amount/-",
            style: cormorantInfantBold.copyWith(
              color: bold ? const Color(0xff9D1911) : ColorResources.blackColor,
              fontSize: bold ? Dimensions.spacingSize18 : Dimensions.fontSizeDefault,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- TRUST FOOTER ----------------
  Widget _trustFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xff9D1911), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "All payments are secure and managed by Mata Tripura Sundari "
              "Shaktipeeth e-Darshan",
              style: avenirNextRegular.copyWith(
                color: ColorResources.textLight,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
