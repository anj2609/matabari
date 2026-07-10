import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/prasad_detail_screen.dart';

class PrasadScreen extends StatefulWidget {
  const PrasadScreen({super.key});

  @override
  State<PrasadScreen> createState() => _PrasadScreenState();
}

class _PrasadScreenState extends State<PrasadScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int selectedCategory = 0;
  final Map<String, int> cart = {};
  final Set<String> favorites = {};

  final List<Map<String, String>> categories = const [
    {"image": "assets/images/laddu.png", "title": "Laddu"},
    {"image": "assets/images/Rectangle 666.png", "title": "Coconut"},
    {"image": "assets/images/Rectangle 786.png", "title": "Sweets"},
    {"image": "assets/images/Rectangle 672.png", "title": "Flowers"},
    {"image": "assets/images/ramdana.png", "title": "Dry Fruit"},
  ];

  final List<Map<String, dynamic>> featuredPrasad = const [
    {
      "title": "Mata Prasad Box",
      "price": 299,
      "image": "assets/images/prasad.png",
      "badge": "Best Seller",
    },
    {
      "title": "Dry Fruit Prasad",
      "price": 499,
      "image": "assets/images/ramdana.png",
    },
    {
      "title": "Coconut Prasad",
      "price": 149,
      "image": "assets/images/Rectangle 666.png",
    },
  ];

  final List<Map<String, dynamic>> templeRecommended = const [
    {
      "title": "Panchamrit Kit",
      "price": 199,
      "image": "assets/images/prasad1.png",
      "tag": "Ritual Offering",
    },
    {
      "title": "Flower Laddoo",
      "price": 249,
      "image": "assets/images/laddu.png",
      "tag": "Festive Special",
    },
    {
      "title": "Navratri Prasad Box",
      "price": 349,
      "image": "assets/images/Rectangle 786.png",
      "tag": "Temple Blessed",
    },
  ];

  final List<Map<String, dynamic>> prasadCombos = const [
    {
      "title": "Festival Combo",
      "price": 599,
      "image": "assets/images/Rectangle 786.png",
    },
    {
      "title": "Navratri Pack",
      "price": 449,
      "image": "assets/images/Rectangle 672.png",
    },
    {
      "title": "Family Blessing Box",
      "price": 799,
      "image": "assets/images/prasad.png",
    },
  ];

  final List<Map<String, dynamic>> allPrasad = const [
    {"title": "Coconut", "price": 51, "image": "assets/images/Rectangle 666.png"},
    {"title": "Sweet Mithai", "price": 151, "image": "assets/images/Rectangle 786.png"},
    {"title": "Dry Fruit Mix", "price": 251, "image": "assets/images/ramdana.png"},
    {"title": "Red Sindoor", "price": 51, "image": "assets/images/kumkum.png"},
    {"title": "Laddu Box", "price": 121, "image": "assets/images/laddu.png"},
    {"title": "Panchamrit", "price": 101, "image": "assets/images/prasad1.png"},
    {"title": "Flowers", "price": 101, "image": "assets/images/Rectangle 672.png"},
    {"title": "Modak", "price": 141, "image": "assets/images/prasad.png"},
  ];

  int get _cartCount => cart.values.fold(0, (a, b) => a + b);

  void _addItem(String title) => setState(() => cart[title] = (cart[title] ?? 0) + 1);

  void _removeItem(String title) => setState(() {
    final q = cart[title] ?? 0;
    if (q <= 1) {
      cart.remove(title);
    } else {
      cart[title] = q - 1;
    }
  });

  void _toggleFavorite(String title) => setState(() {
    if (favorites.contains(title)) {
      favorites.remove(title);
    } else {
      favorites.add(title);
    }
  });

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PrasadDetailScreen(prasad: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _heroBanner(),
              ),
              const SizedBox(height: 20),
              _categoryRow(),
              const SizedBox(height: 22),

              _sectionHeader("Featured Prasad"),
              const SizedBox(height: 12),
              _productRow(featuredPrasad),
              const SizedBox(height: 22),

              _sectionHeader("Temple Recommended"),
              const SizedBox(height: 12),
              _productRow(templeRecommended),
              const SizedBox(height: 22),

              _sectionHeader("Prasad Combos"),
              const SizedBox(height: 12),
              _productRow(prasadCombos),
              const SizedBox(height: 22),

              _sectionHeader("All Prasad"),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _allPrasadGrid(),
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Icon(Icons.arrow_back, color: ColorResources.blackColor),
          ),
          _gradientText(
            "Prasad Store",
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize22),
          ),
          GestureDetector(
            onTap: () => _notify(
              _cartCount == 0 ? "Your cart is empty" : "$_cartCount item(s) in cart",
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_bag_outlined, color: ColorResources.blackColor),
                if (_cartCount > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE07A00),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        "$_cartCount",
                        textAlign: TextAlign.center,
                        style: cormorantInfantBold.copyWith(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- HERO BANNER ----------------
  Widget _heroBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1DD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Offer Sacred Prasad at",
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  _gradientText(
                    "Mata Tripura Sundari",
                    cormorantInfantBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Let your devotion reach the divine",
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => _notify("Browsing today's special prasad"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE07A00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Order Now",
                        style: cormorantInfantBold.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.spacingSize16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(22),
              bottomRight: Radius.circular(22),
            ),
            child: Image.asset(
              "assets/images/prasad.png",
              height: 140,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- CATEGORY ROW ----------------
  Widget _categoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (index) {
          final selected = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: Column(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: selected ? _redGradient : null,
                    border: selected
                        ? null
                        : Border.all(color: const Color(0xffF3D8B3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      categories[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  categories[index]['title']!,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _gradientText(
            title,
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Text(
              "View All",
              style: avenirNextCyr.copyWith(
                color: ColorResources.kOrange,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- PRODUCT ROW (Featured / Recommended / Combos) ----------------
  Widget _productRow(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 214,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _productCard(items[index]),
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> item) {
    final title = item['title'] as String;
    final price = item['price'] as int;
    final badge = item['badge'] as String?;
    final tag = item['tag'] as String?;
    final qty = cart[title] ?? 0;
    final isFav = favorites.contains(title);

    return GestureDetector(
      onTap: () => _openDetail(item),
      child: Container(
      width: 148,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item['image'] as String,
                  height: 96,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE07A00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(title),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .85),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 14,
                      color: const Color(0xFFE07A00),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: cormorantInfantBold.copyWith(
              color: ColorResources.blackColor,
              fontSize: Dimensions.spacingSize14,
            ),
          ),
          if (tag != null)
            Text(
              tag,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: avenirNextRegular.copyWith(
                color: const Color(0xff9D1911),
                fontSize: 9,
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹$price/-",
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.kOrange,
                  fontSize: Dimensions.spacingSize16,
                ),
              ),
              _cartControl(title, qty, compact: true),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _cartControl(String title, int qty, {bool compact = false}) {
    final size = compact ? 26.0 : 28.0;

    if (qty == 0) {
      return GestureDetector(
        onTap: () => _addItem(title),
        child: Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(color: Color(0xFFE07A00), shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.white, size: 16),
        ),
      );
    }

    return Container(
      height: size,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE07A00),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _removeItem(title),
            child: const Icon(Icons.remove, color: Colors.white, size: 14),
          ),
          SizedBox(
            width: 20,
            child: Text(
              "$qty",
              textAlign: TextAlign.center,
              style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: () => _addItem(title),
            child: const Icon(Icons.add, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }

  /// ---------------- ALL PRASAD GRID ----------------
  Widget _allPrasadGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      itemCount: allPrasad.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final item = allPrasad[index];
        final title = item['title'] as String;
        final price = item['price'] as int;
        final qty = cart[title] ?? 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => _openDetail(item),
              child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: qty > 0 ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
                  width: qty > 0 ? 1.4 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1.1,
                        child: Image.asset(item['image'] as String, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: 11,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      "₹$price/-",
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.kOrange,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
            Positioned(right: 4, bottom: -12, child: _cartControl(title, qty, compact: true)),
          ],
        );
      },
    );
  }
}
