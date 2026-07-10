import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/puja_detail_screen.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class SavedCollectionScreen extends StatefulWidget {
  const SavedCollectionScreen({super.key});

  @override
  State<SavedCollectionScreen> createState() => _SavedCollectionScreenState();
}

class _SavedCollectionScreenState extends State<SavedCollectionScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int selectedTab = 0;
  final Set<String> unsaved = {};

  final List<Map<String, String>> recentlySaved = const [
    {"title": "Hanuman Chalisa", "image": "assets/images/hanumanji.png"},
    {"title": "Shri Vishnu Chalisa", "image": "assets/images/ram.png"},
    {"title": "Shani Dev Chalisa", "image": "assets/images/shivji.png"},
  ];

  final List<Map<String, String>> favouriteAartis = const [
    {"title": "Maa Ki Aarti", "image": "assets/images/maa.png"},
    {"title": "Om Jai Jagdish", "image": "assets/images/lakshamiji.png"},
    {"title": "Jai Shri Krishna", "image": "assets/images/temple.png"},
  ];

  final List<Map<String, dynamic>> savedPujas = const [
    {
      "title": "Maa Tripura Sundari Puja",
      "description": "Invoke blessings of prosperity, beauty & happiness.",
      "tag": "Family Puja",
      "duration": "2 Hours",
      "price": "₹499/-",
      "image": "assets/images/Rectangle 693.png",
    },
    {
      "title": "Navgraha Shanti Puja",
      "description": "Balance planetary influences for a smoother life.",
      "tag": "Family Puja",
      "duration": "2.5 Hours",
      "price": "₹699/-",
      "image": "assets/images/Rectangle 720.png",
    },
    {
      "title": "Kumari Puja",
      "description": "Seek blessings of the divine feminine energy.",
      "tag": "Individual Puja",
      "duration": "1.5 Hours",
      "price": "₹399/-",
      "image": "assets/images/Rectangle 708.png",
    },
  ];

  final List<Map<String, dynamic>> savedOfferings = const [
    {"title": "Coconut", "price": 51, "image": "assets/images/Rectangle 666.png"},
    {"title": "Sweet Mithai", "price": 151, "image": "assets/images/Rectangle 786.png"},
    {"title": "Chunri", "price": 101, "image": "assets/images/Rectangle 673.png"},
    {"title": "Deepdaan", "price": 51, "image": "assets/images/Rectangle 788.png"},
  ];

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  List<Map<String, String>> _visible(List<Map<String, String>> list) =>
      list.where((e) => !unsaved.contains(e['title'])).toList();

  List<Map<String, dynamic>> _visibleDynamic(List<Map<String, dynamic>> list) =>
      list.where((e) => !unsaved.contains(e['title'] as String)).toList();

  @override
  Widget build(BuildContext context) {
    final visibleRecentlySaved = _visible(recentlySaved);
    final visibleFavouriteAartis = _visible(favouriteAartis);
    final visibleSavedPujas = _visibleDynamic(savedPujas);

    final showPuja = selectedTab == 0 || selectedTab == 1;
    final showAarti = selectedTab == 0 || selectedTab == 2;
    final showOfferings = selectedTab == 0 || selectedTab == 3;

    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              _statsRow(),
              const SizedBox(height: 20),

              if (showAarti) ...[
                _sectionHeader("Recently Saved"),
                const SizedBox(height: 10),
                _squareRow(visibleRecentlySaved),
                const SizedBox(height: 20),

                _sectionHeader("Favourite Aartis"),
                const SizedBox(height: 10),
                _squareRow(visibleFavouriteAartis),
                const SizedBox(height: 20),
              ],

              if (showPuja) ...[
                _sectionHeader("Saved Pujas"),
                const SizedBox(height: 10),
                if (visibleSavedPujas.isEmpty)
                  _emptyRow("No saved pujas")
                else
                  ...visibleSavedPujas.map(_pujaCard),
                const SizedBox(height: 20),
              ],

              if (showOfferings) ...[
                _sectionHeader("Saved Offerings"),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _offeringsRow(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: _redGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
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
                      "Saved Collection",
                      style: cormorantInfantBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.spacingSize22,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Your saved puja and offerings",
                      style: avenirNextRegular.copyWith(
                        color: Colors.white70,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .2),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(4, (index) => _tabButton(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(int index) {
    final labels = ["All", "Puja", "Aarti", "Offerings"];
    final active = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: active ? _redGradient : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              labels[index],
              style: cormorantInfantBold.copyWith(
                color: active ? Colors.white : ColorResources.textLight,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- STATS ----------------
  Widget _statsRow() {
    final stats = [
      ("12", "Saved Puja"),
      ("18", "Saved Aarti"),
      ("06", "Saved Bhajan"),
      ("09", "Saved Offerings"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: Column(
                children: [
                  Text(
                    s.$1,
                    style: cormorantInfantBold.copyWith(
                      color: const Color(0xff9D1911),
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.$2,
                    textAlign: TextAlign.center,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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

  /// ---------------- SQUARE ROW (Chalisa / Aarti) ----------------
  Widget _squareRow(List<Map<String, String>> items) {
    if (items.isEmpty) return _emptyRow("Nothing saved here yet");

    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 84,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        item['image']!,
                        height: 84,
                        width: 84,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => unsaved.add(item['title']!)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite, size: 12, color: Color(0xFFE07A00)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ---------------- SAVED PUJA CARD ----------------
  Widget _pujaCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                item['image'] as String,
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
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => unsaved.add(item['title'] as String)),
                        child: const Icon(Icons.favorite, size: 18, color: Color(0xFFE07A00)),
                      ),
                    ],
                  ),
                  Text(
                    item['tag'] as String,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        item['price'] as String,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.kOrange,
                          fontSize: Dimensions.spacingSize16,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PujaDetailScreen(puja: item),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: _redGradient,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            "Book Now",
                            style: cormorantInfantBold.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- SAVED OFFERINGS ----------------
  Widget _offeringsRow() {
    return Row(
      children: savedOfferings.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffF3D8B3)),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item['image'] as String,
                    height: 48,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: 10,
                  ),
                ),
                Text(
                  "₹${item['price']}/-",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.kOrange,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _notify("Added ${item['title']} to cart"),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xff9D1911)),
                    ),
                    child: Text(
                      "Add",
                      style: cormorantInfantBold.copyWith(
                        color: const Color(0xff9D1911),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
