import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/devotee/aarti_player_screen.dart';

class AartiScreen extends StatefulWidget {
  const AartiScreen({super.key});

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int selectedTab = 0;
  int selectedCategory = 0;

  final List<Map<String, String>> tabs = const [
    {"title": "AARTI", "icon": "flame"},
    {"title": "CHALISA", "icon": "book"},
    {"title": "BHAJAN", "icon": "music"},
  ];

  final List<Map<String, dynamic>> categories = const [
    {"icon": Icons.wb_twilight, "title": "Morning\nAarti"},
    {"icon": Icons.nightlight_round, "title": "Evening\nAarti"},
    {"icon": Icons.celebration_outlined, "title": "Festival\nSpecial"},
    {"icon": Icons.favorite_border, "title": "My\nFavourite"},
    {"icon": Icons.history, "title": "Recently\nPlayed"},
  ];

  final List<Map<String, dynamic>> trendingAartis = const [
    {
      "title": "Maa Tripura Sundari Aarti",
      "sub": "Morning Aarti",
      "duration": "12 Min",
      "plays": "12.3K Plays",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
      "ai": false,
    },
    {
      "title": "Jai Ambe Gauri Aarti",
      "sub": "Evening Aarti",
      "duration": "8 Min",
      "plays": "9.6K Plays",
      "image": "assets/images/maa.png",
      "audio": "assets/audio/laximimata.mp3",
      "ai": false,
    },
    {
      "title": "Durga Aarti",
      "sub": "Festive Special",
      "duration": "10 Min",
      "plays": "18.3K Plays",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
      "ai": true,
    },
    {
      "title": "Om Jai Jagdish Hare Aarti",
      "sub": "Popular Aarti",
      "duration": "9 Min",
      "plays": "22.4K Plays",
      "image": "assets/images/lakshamiji.png",
      "audio": "assets/audio/laximimata.mp3",
      "ai": false,
    },
  ];

  final List<Map<String, String>> popularAartis = const [
    {
      "title": "Hanuman Aarti",
      "duration": "10 Min",
      "image": "assets/images/hanumanji.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Durga Aarti",
      "duration": "12 Min",
      "image": "assets/images/maa.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Bhairav Aarti",
      "duration": "8 Min",
      "image": "assets/images/shivji.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Kali Aarti",
      "duration": "10 Min",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
    },
  ];

  final List<Map<String, String>> topAartis = const [
    {
      "title": "Shri Ganesh Aarti",
      "sub": "Daily Aarti",
      "duration": "6 Min",
      "plays": "21.4K Plays",
      "image": "assets/images/dailyaarti.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Shri Vishnu Aarti",
      "sub": "Daily Special",
      "duration": "7 Min",
      "plays": "19.8K Plays",
      "image": "assets/images/ram.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Shri Krishna Aarti",
      "sub": "Daily Special",
      "duration": "9 Min",
      "plays": "15.8K Plays",
      "image": "assets/images/temple.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Shri Devi Aarti",
      "sub": "Popular Aarti",
      "duration": "8 Min",
      "plays": "9.2K Plays",
      "image": "assets/images/lakshamiji.png",
      "audio": "assets/audio/laximimata.mp3",
    },
  ];

  final List<Map<String, dynamic>> chalisaCategories = const [
    {"icon": Icons.wb_twilight, "title": "Morning\nChalisa"},
    {"icon": Icons.nightlight_round, "title": "Evening\nChalisa"},
    {"icon": Icons.celebration_outlined, "title": "Festival\nChalisa"},
    {"icon": Icons.favorite_border, "title": "My\nFavourite"},
    {"icon": Icons.history, "title": "Recently\nPlayed"},
  ];

  final List<Map<String, dynamic>> trendingChalisas = const [
    {
      "title": "Hanuman Chalisa",
      "sub": "Powerful Chalisa",
      "badge": "Powerful Chalisa",
      "duration": "8 Min",
      "plays": "256 Reads",
      "image": "assets/images/hanumanji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
      "ai": false,
    },
    {
      "title": "Durga Chalisa",
      "sub": "For Strength & Protection",
      "duration": "9 Min",
      "plays": "16.2K Reads",
      "image": "assets/images/maa.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
      "ai": false,
    },
    {
      "title": "Shiv Chalisa",
      "sub": "For peace & inner strength",
      "duration": "8 Min",
      "plays": "14.5K Reads",
      "image": "assets/images/shivji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
      "ai": false,
    },
    {
      "title": "Ganesh Chalisa",
      "sub": "For Wisdom & success",
      "duration": "7 Min",
      "plays": "11.9K Reads",
      "image": "assets/images/dailyaarti.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
      "ai": false,
    },
  ];

  final List<Map<String, String>> popularChalisas = const [
    {
      "title": "Ram Chalisa",
      "duration": "8 Min",
      "image": "assets/images/ram.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
    {
      "title": "Krishna Chalisa",
      "duration": "9 Min",
      "image": "assets/images/temple.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
    {
      "title": "Vishnu Chalisa",
      "duration": "8 Min",
      "image": "assets/images/dailyaarti.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
    {
      "title": "Laxmi Chalisa",
      "duration": "7 Min",
      "image": "assets/images/lakshamiji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
  ];

  final List<Map<String, String>> topChalisas = const [
    {
      "title": "Shri Ganesh Chalisa",
      "sub": "Morning Chalisa",
      "duration": "7 Min",
      "plays": "21.4K Reads",
      "image": "assets/images/dailyaarti.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
    {
      "title": "Kali Chalisa",
      "sub": "For Protection & Fear Removal",
      "duration": "9 Min",
      "plays": "18.3K Reads",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
    {
      "title": "Saraswati Chalisa",
      "sub": "For Knowledge & Learning",
      "duration": "8 Min",
      "plays": "13.6K Reads",
      "image": "assets/images/temple.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
    {
      "title": "Shri Shani Dev Chalisa",
      "sub": "For Karma Shanti",
      "duration": "10 Min",
      "plays": "9.5K Reads",
      "image": "assets/images/shivji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "chalisa",
    },
  ];

  final List<Map<String, dynamic>> bhajanCategories = const [
    {"icon": Icons.trending_up, "title": "Trending\nBhajans"},
    {"icon": Icons.self_improvement, "title": "Devotional\nBhajans"},
    {"icon": Icons.queue_music, "title": "My\nPlaylist"},
    {"icon": Icons.favorite_border, "title": "My\nFavorite"},
    {"icon": Icons.history, "title": "Recently\nPlayed"},
  ];

  final List<Map<String, dynamic>> trendingBhajans = const [
    {
      "title": "Madhurashtakam",
      "sub": "Krishna Bhajan",
      "duration": "02:15 Min",
      "plays": "65.8K Plays",
      "image": "assets/images/temple.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
      "ai": false,
    },
    {
      "title": "Ye Charnak Ye Dhamak",
      "sub": "Devotional Bhajan",
      "duration": "01:34 Min",
      "plays": "38.2K Plays",
      "image": "assets/images/dailyaarti.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
      "ai": false,
    },
    {
      "title": "Raja Ram Bar",
      "sub": "Ram Bhajan",
      "duration": "04:41 Min",
      "plays": "22.9K Plays",
      "image": "assets/images/ram.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
      "ai": false,
    },
    {
      "title": "Om Jai Jagdish Hare",
      "sub": "Aarti Bhajan",
      "duration": "03:00 Min",
      "plays": "19.4K Plays",
      "image": "assets/images/lakshamiji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
      "ai": false,
    },
  ];

  final List<Map<String, String>> popularBhajans = const [
    {
      "title": "Shiv Shambhu",
      "duration": "20:35 Min",
      "image": "assets/images/shivji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
    {
      "title": "Jai Ganesh",
      "duration": "15:15 Min",
      "image": "assets/images/dailyaarti.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
    {
      "title": "Banke Bihari Lal",
      "duration": "12:15 Min",
      "image": "assets/images/temple.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
    {
      "title": "Radhe Krishna",
      "duration": "12:00 Min",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
  ];

  final List<Map<String, String>> topBhajans = const [
    {
      "title": "Har Har Shambhu",
      "sub": "Shiv Bhajan",
      "duration": "02:15 Min",
      "plays": "27.8K Plays",
      "image": "assets/images/shivji.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
    {
      "title": "Achyutam Keshavam",
      "sub": "Krishna Bhajan",
      "duration": "03:35 Min",
      "plays": "20.3K Plays",
      "image": "assets/images/temple.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
    {
      "title": "Raghupati Raghav Raja Ram",
      "sub": "Ram Bhajan",
      "duration": "02:56 Min",
      "plays": "17.6K Plays",
      "image": "assets/images/ram.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
    {
      "title": "Jai Ambe Gauri",
      "sub": "Devi Bhajan",
      "duration": "03:12 Min",
      "plays": "9.2K Plays",
      "image": "assets/images/maa.png",
      "audio": "assets/audio/laximimata.mp3",
      "type": "bhajan",
    },
  ];

  bool get _isChalisaTab => selectedTab == 1;
  bool get _isBhajanTab => selectedTab == 2;

  List<Map<String, dynamic>> get _activeCategories {
    if (_isChalisaTab) return chalisaCategories;
    if (_isBhajanTab) return bhajanCategories;
    return categories;
  }

  List<Map<String, dynamic>> get _activeTrending {
    if (_isChalisaTab) return trendingChalisas;
    if (_isBhajanTab) return trendingBhajans;
    return trendingAartis;
  }

  List<Map<String, String>> get _activePopular {
    if (_isChalisaTab) return popularChalisas;
    if (_isBhajanTab) return popularBhajans;
    return popularAartis;
  }

  List<Map<String, String>> get _activeTop {
    if (_isChalisaTab) return topChalisas;
    if (_isBhajanTab) return topBhajans;
    return topAartis;
  }

  String get _trendingTitle {
    if (_isChalisaTab) return "Trending Chalisa";
    if (_isBhajanTab) return "Trending Bhajans";
    return "Trending Aartis";
  }

  String get _popularTitle {
    if (_isChalisaTab) return "Popular Chalisa";
    if (_isBhajanTab) return "Popular Bhajan";
    return "Popular Aarti";
  }

  String get _topTitle {
    if (_isChalisaTab) return "Top Chalisa";
    if (_isBhajanTab) return "Top Bhajan";
    return "Top Aarti";
  }

  List<Map<String, dynamic>> get _allAartis => [
    ..._activeTrending,
    ..._activePopular,
    ..._activeTop,
  ];

  void _openPlayer(Map<String, dynamic> item) {
    final related = _allAartis
        .where((e) => e['title'] != item['title'])
        .take(4)
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AartiPlayerScreen(aarti: item, related: related),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F4EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 18),
              _categoryRow(),
              const SizedBox(height: 24),

              _sectionHeader(_trendingTitle),
              const SizedBox(height: 10),
              ..._activeTrending.map(_aartiListCard),
              const SizedBox(height: 22),

              _sectionHeader(_popularTitle),
              const SizedBox(height: 12),
              _popularAartiRow(),
              const SizedBox(height: 22),

              _sectionHeader(_topTitle),
              const SizedBox(height: 10),
              ..._activeTop.map(_aartiListCard),
              const SizedBox(height: 16),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIconButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.maybePop(context),
              ),
              Text(
                "Aarti/Chalisa/Bhajan",
                style: cormorantInfantBold.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.spacingSize22,
                ),
              ),
              _circleIconButton(icon: Icons.search, onTap: () {}),
            ],
          ),
          const SizedBox(height: Dimensions.fontSizeSmall),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFFABB46),
                Color(0xFFFEF39E),
                Color(0xFFF2C639),
              ],
              stops: [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: Text(
              "Listen, pray and feel the divine",
              textAlign: TextAlign.center,
              style: avenirNextCyr.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Image.asset(
            'assets/images/Frame.png',
            height: 14,
            color: const Color(0xFFFEF39E),
          ),
          const SizedBox(height: 18),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(
                tabs.length,
                (index) => _tabButton(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .2),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _tabButton(int index) {
    final active = selectedTab == index;
    final icons = [
      Icons.local_fire_department,
      Icons.menu_book_outlined,
      Icons.music_note,
    ];

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            gradient: active ? _redGradient : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons[index],
                size: 14,
                color: active ? Colors.white : ColorResources.textLight,
              ),
              const SizedBox(width: 4),
              Text(
                tabs[index]['title']!,
                style: cormorantInfantBold.copyWith(
                  color: active ? Colors.white : ColorResources.textLight,
                  fontSize: Dimensions.spacingSize14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- CATEGORY ROW ----------------
  Widget _categoryRow() {
    final items = _activeCategories;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final selected = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: Column(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: selected ? _redGradient : null,
                    color: selected ? null : const Color(0xFFFFFBF2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? const Color(0xff9D1911)
                          : const Color(0xffF3D8B3),
                    ),
                  ),
                  child: Icon(
                    items[index]['icon'] as IconData,
                    color: selected ? Colors.white : ColorResources.kOrange,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items[index]['title'] as String,
                  textAlign: TextAlign.center,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: 9,
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
          Text(
            "View All",
            style: avenirNextCyr.copyWith(
              color: ColorResources.kOrange,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- AARTI LIST CARD (Trending / Top) ----------------
  Widget _aartiListCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _openPlayer(item),
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item['image'] as String,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              if (item['ai'] == true)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE07A00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "AI",
                      style: cormorantInfantBold.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, size: 11, color: Color(0xffF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      item['sub'] as String,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 11, color: Color(0xffF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      item['duration'] as String,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: ColorResources.textLight,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _openPlayer(item),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE07A00),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  /// ---------------- POPULAR AARTI ROW ----------------
  Widget _popularAartiRow() {
    final items = _activePopular;
    return SizedBox(
      height: 122,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => _openPlayer(item),
            child: SizedBox(
              width: 78,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      item['image']!,
                      height: 78,
                      width: 78,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize14,
                    ),
                  ),
                  Text(
                    item['duration']!,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 9,
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
}
