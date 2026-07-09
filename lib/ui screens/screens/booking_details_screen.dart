import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';
import 'package:matabari/widgets/formfield.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> puja;

  const BookingDetailsScreen({super.key, required this.puja});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int? selectedPandit;
  final Map<int, int> chadavaQty = {};
  bool showFamilyMember = false;
  bool showCustomChadavaInput = false;
  final List<String> customChadavaEntries = [];

  final nameController = TextEditingController();
  final gotraController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final customChadavaController = TextEditingController();
  final familyNameController = TextEditingController();

  final List<Map<String, String>> pandits = const [
    {
      "image": "assets/images/pandit1.jpg",
      "name": "Pandit Rajesh Shastri",
      "experience": "15+ Years Exp.",
      "rating": "4.9",
    },
    {
      "image": "assets/images/pandit2.jpg",
      "name": "Pandit Vishnu Sharma",
      "experience": "20+ Years Exp.",
      "rating": "4.8",
    },
    {
      "image": "assets/images/pandit3.png",
      "name": "Pandit Mahesh Tiwari",
      "experience": "12+ Years Exp.",
      "rating": "4.7",
    },
  ];

  final List<Map<String, dynamic>> chadavaItems = const [
    {"asset": "assets/images/Rectangle 666.png", "title": "Coconut", "price": 51},
    {"asset": "assets/images/Rectangle 672.png", "title": "Flowers", "price": 101},
    {"asset": "assets/images/Rectangle 790.png", "title": "Red Saree", "price": 251},
    {"asset": "assets/images/Rectangle 786.png", "title": "Sweet/Bhog", "price": 151},
    {"asset": "assets/images/Rectangle 788.png", "title": "Deepdaan", "price": 51},
    {"asset": "assets/images/Rectangle 673.png", "title": "Chunri", "price": 101},
  ];

  int get _basePrice => _parsePrice(widget.puja['price'] ?? '0');
  int get _chadavaTotal => chadavaQty.entries.fold(
    0,
    (sum, e) => sum + (chadavaItems[e.key]['price'] as int) * e.value,
  );
  static const int _convenienceFee = 51;
  int get _totalAmount => _basePrice + _chadavaTotal + _convenienceFee;

  int _parsePrice(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  @override
  void dispose() {
    nameController.dispose();
    gotraController.dispose();
    addressController.dispose();
    phoneController.dispose();
    customChadavaController.dispose();
    familyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F5F0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorResources.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: _gradientText(
          "Select Pandit Ji",
          cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize22),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _bookFooterBar(),
          const CustomBottomNavBar(currentIndex: 1, onTap: _noOpNav),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "See All",
                style: avenirNextCyr.copyWith(
                  color: ColorResources.kOrange,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _panditList(),
            const SizedBox(height: 24),

            _gradientText(
              "Add Chadava (Optional)",
              cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
            ),
            const SizedBox(height: 12),
            _chadavaGrid(),
            const SizedBox(height: 14),
            _customChadavaField(),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: "Name",
                    hint: "Enter your name",
                    controller: nameController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LabeledTextField(
                    label: "Gotra Number",
                    hint: "Enter gotra",
                    controller: gotraController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            LabeledTextField(
              label: "Address",
              hint: "Enter your address",
              controller: addressController,
              maxLines: 2,
            ),
            const SizedBox(height: 15),
            LabeledTextField(
              label: "Phone Number",
              hint: "Enter phone number",
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 18),

            _addFamilyMember(),
            const SizedBox(height: 24),

            _priceDetails(),
          ],
        ),
      ),
    );
  }

  static void _noOpNav(int index) {}

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  /// ---------------- PANDIT LIST ----------------
  Widget _panditList() {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pandits.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final selected = selectedPandit == index;
          final pandit = pandits[index];

          return GestureDetector(
            onTap: () => setState(() => selectedPandit = index),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? const Color(0xff9D1911)
                      : const Color(0xffF3D8B3),
                  width: selected ? 1.6 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          pandit['image']!,
                          height: 90,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xffFF9F0A),
                                size: 11,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                pandit['rating']!,
                                style: cormorantInfantBold.copyWith(
                                  color: ColorResources.blackColor,
                                  fontSize: Dimensions.spacingSize11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pandit['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pandit['experience']!,
                          style: avenirNextRegular.copyWith(
                            color: ColorResources.textLight,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ---------------- CHADAVA GRID ----------------
  Widget _chadavaGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      itemCount: chadavaItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 18,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = chadavaItems[index];
        final qty = chadavaQty[index] ?? 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: qty > 0 ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
                  width: qty > 0 ? 1.4 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: Image.asset(item['asset'] as String, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "₹${item['price']}/-",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.kOrange,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(right: 6, bottom: -12, child: _chadavaControl(index)),
          ],
        );
      },
    );
  }

  Widget _chadavaControl(int index) {
    final qty = chadavaQty[index] ?? 0;

    if (qty == 0) {
      return GestureDetector(
        onTap: () => setState(() => chadavaQty[index] = 1),
        child: Container(
          height: 28,
          width: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFE07A00),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 16),
        ),
      );
    }

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE07A00),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              if (qty <= 1) {
                chadavaQty.remove(index);
              } else {
                chadavaQty[index] = qty - 1;
              }
            }),
            child: const Icon(Icons.remove, color: Colors.white, size: 14),
          ),
          SizedBox(
            width: 22,
            child: Text(
              "$qty",
              textAlign: TextAlign.center,
              style: cormorantInfantBold.copyWith(
                color: Colors.white,
                fontSize: Dimensions.spacingSize14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => chadavaQty[index] = qty + 1),
            child: const Icon(Icons.add, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _customChadavaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(
            () => showCustomChadavaInput = !showCustomChadavaInput,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/Group 57.png",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (showCustomChadavaInput) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: customChadavaController,
                  style: LabeledTextField.inputStyle,
                  decoration: LabeledTextField.fieldDecoration(
                    "Describe your offering",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final text = customChadavaController.text.trim();
                  if (text.isEmpty) return;
                  setState(() {
                    customChadavaEntries.add(text);
                    customChadavaController.clear();
                  });
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    gradient: _redGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
        if (customChadavaEntries.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: customChadavaEntries.map((entry) {
              return Chip(
                label: Text(
                  entry,
                  style: avenirNextRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                backgroundColor: const Color(0xFFFFF4E6),
                side: const BorderSide(color: Color(0xffF3D8B3)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () =>
                    setState(() => customChadavaEntries.remove(entry)),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// ---------------- ADD FAMILY MEMBER ----------------
  Widget _addFamilyMember() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => showFamilyMember = !showFamilyMember),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffF3D8B3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_add_alt_1, color: Color(0xff9D1911), size: 18),
                const SizedBox(width: 8),
                Text(
                  "Add Family Member",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showFamilyMember) ...[
          const SizedBox(height: 12),
          LabeledTextField(
            label: "Family Member Name",
            hint: "Enter name",
            controller: familyNameController,
          ),
        ],
      ],
    );
  }

  /// ---------------- PRICE DETAILS ----------------
  Widget _priceDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const SizedBox(height: 12),
          _priceRow("Puja Base Price", _basePrice),
          _priceRow("Selected Chadhava", _chadavaTotal),
          _priceRow("Convenience Fee", _convenienceFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Color(0xffF3D8B3)),
          ),
          _priceRow("Total Amount", _totalAmount, bold: true),
        ],
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

  /// ---------------- FOOTER BOOK BUTTON ----------------
  Widget _bookFooterBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  size: 14, color: ColorResources.textLight),
              const SizedBox(width: 6),
              Text(
                "Pay via UPI",
                style: avenirNextRegular.copyWith(
                  color: ColorResources.textLight,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: _redGradient,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹$_totalAmount/-",
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Book Puja",
                        style: cormorantInfantBold.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.spacingSize18,
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
        ],
      ),
    );
  }
}
