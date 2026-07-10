import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class PrasadDetailScreen extends StatefulWidget {
  final Map<String, dynamic> prasad;

  const PrasadDetailScreen({super.key, required this.prasad});

  @override
  State<PrasadDetailScreen> createState() => _PrasadDetailScreenState();
}

class _PrasadDetailScreenState extends State<PrasadDetailScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int quantity = 1;
  bool isFavorite = false;

  final List<Map<String, dynamic>> features = const [
    {"icon": Icons.eco_outlined, "title": "100%\nPure & Natural"},
    {"icon": Icons.block_outlined, "title": "No Added\nPreservatives"},
    {"icon": Icons.favorite_border, "title": "Prepared with\nDevotion"},
    {"icon": Icons.temple_hindu_outlined, "title": "Blessed at\nTemple"},
  ];

  int _parsePrice(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final prasad = widget.prasad;
    final String title = prasad['title'] as String? ?? '';
    final String subtitle = prasad['subtitle'] as String? ?? 'Pure Desi Ghee Prasad';
    final String image = prasad['image'] as String? ?? '';
    final String? badge = prasad['badge'] as String?;
    final int rawPrice = prasad['price'] is int
        ? prasad['price'] as int
        : _parsePrice(prasad['price']?.toString() ?? '0');
    final int totalAmount = rawPrice * quantity;

    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _footerBar(totalAmount),
          CustomBottomNavBar(
            currentIndex: 3,
            onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 12),
              _productImage(image, badge),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.fontSizeExtraLarge,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: avenirNextRegular.copyWith(
                            color: ColorResources.textLight,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "₹$rawPrice/-",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.kOrange,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Blessed at Mata Tripura Sundari Temple",
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              _quantitySelector(),
              const SizedBox(height: 20),

              _featureRow(),
              const SizedBox(height: 20),

              _aboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Icon(Icons.arrow_back, color: ColorResources.blackColor),
        ),
        _gradientText(
          "Prasad Detail",
          cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize22),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => isFavorite = !isFavorite),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? const Color(0xFFE07A00) : ColorResources.blackColor,
              ),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () => _notify("Sharing ${widget.prasad['title']}"),
              child: Icon(Icons.share_outlined, color: ColorResources.blackColor),
            ),
          ],
        ),
      ],
    );
  }

  /// ---------------- PRODUCT IMAGE ----------------
  Widget _productImage(String image, String? badge) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            image,
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (badge != null)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE07A00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
      ],
    );
  }

  /// ---------------- QUANTITY SELECTOR ----------------
  Widget _quantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Quantity",
            style: cormorantInfantBold.copyWith(
              color: ColorResources.blackColor,
              fontSize: Dimensions.spacingSize16,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xffF3D8B3)),
                  ),
                  child: const Icon(Icons.remove, size: 16, color: Color(0xff9D1911)),
                ),
              ),
              SizedBox(
                width: 34,
                child: Text(
                  "$quantity",
                  textAlign: TextAlign.center,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => quantity += 1),
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: const BoxDecoration(color: Color(0xFFE07A00), shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- FEATURE ROW ----------------
  Widget _featureRow() {
    return Row(
      children: features.map((f) {
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E6),
                  shape: BoxShape.circle,
                ),
                child: Icon(f['icon'] as IconData, color: ColorResources.kOrange, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                f['title'] as String,
                textAlign: TextAlign.center,
                style: avenirNextRegular.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// ---------------- ABOUT ----------------
  Widget _aboutSection() {
    return Container(
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
            "About Prasad",
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
          ),
          const SizedBox(height: 8),
          Text(
            "This prasad is prepared with pure desi ghee, besan, sugar and "
            "premium dry fruits. Offered at the holy feet of Mata Tripura "
            "Sundari and then packed with utmost care and devotion.",
            style: avenirNextRegular.copyWith(
              color: ColorResources.textLight,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- FOOTER ----------------
  Widget _footerBar(int totalAmount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _notify("Change payment method"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined,
                        size: 12, color: ColorResources.textLight),
                    const SizedBox(width: 4),
                    Text(
                      "PAY USING",
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Paytm/UPI",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _notify("Offering ${widget.prasad['title']} x$quantity"),
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: _redGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "₹$totalAmount/-",
                          style: cormorantInfantBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.spacingSize16,
                          ),
                        ),
                        Text(
                          "Total Amount",
                          style: avenirNextRegular.copyWith(color: Colors.white70, fontSize: 8),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Offer Prasad",
                          style: cormorantInfantBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.spacingSize16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
