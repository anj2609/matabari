import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/booking_details_screen.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class PujaDetailScreen extends StatefulWidget {
  final Map<String, dynamic> puja;

  const PujaDetailScreen({super.key, required this.puja});

  @override
  State<PujaDetailScreen> createState() => _PujaDetailScreenState();
}

class _PujaDetailScreenState extends State<PujaDetailScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  bool readMore = false;
  bool isFavorite = false;
  int? selectedPujaType;
  int? selectedDate;
  int? selectedTimeSlot;

  final List<Map<String, String>> pujaTypes = const [
    {"title": "Individual", "subtitle": "For personal blessings"},
    {"title": "Family Puja", "subtitle": "For family well-being"},
  ];

  final List<Map<String, String>> dates = const [
    {"day": "Sun", "date": "20"},
    {"day": "Mon", "date": "21"},
    {"day": "Tue", "date": "22"},
    {"day": "Wed", "date": "23"},
    {"day": "Thu", "date": "24"},
  ];

  final List<Map<String, dynamic>> timeSlots = const [
    {"title": "Morning", "time": "6:00 - 9:00 AM", "icon": Icons.wb_sunny_outlined},
    {"title": "Afternoon", "time": "12:00 - 3:00 PM", "icon": Icons.wb_cloudy_outlined},
    {"title": "Evening", "time": "6:00 - 9:00 PM", "icon": Icons.nights_stay_outlined},
  ];

  final List<Map<String, String>> benefits = const [
    {"icon": "assets/images/Dollar Tree.png", "title": "Wealth &\nProsperity"},
    {"icon": "assets/images/Peace of mind.png", "title": "Peace &\nPositivity"},
    {"icon": "assets/images/Harmony.png", "title": "Family\nHarmony"},
    {"icon": "assets/images/Protection.png", "title": "Remove\nNegativity"},
  ];

  final List<Map<String, String>> pujaVidhi = const [
    {"title": "Sankalp", "subtitle": "Intent & resolution for the puja"},
    {"title": "Main Puja", "subtitle": "Core rituals performed by the pandit"},
    {"title": "Havan", "subtitle": "Sacred fire ritual for purification"},
    {"title": "Aarti", "subtitle": "Devotional worship with lamps"},
    {"title": "Prasad", "subtitle": "Blessed offering distributed to devotees"},
  ];

  void _selectPujaType(int index) {
    setState(() => selectedPujaType = index);
    _maybeContinueToBooking();
  }

  void _selectDate(int index) {
    setState(() => selectedDate = index);
    _maybeContinueToBooking();
  }

  void _selectTimeSlot(int index) {
    setState(() => selectedTimeSlot = index);
    _maybeContinueToBooking();
  }

  void _maybeContinueToBooking() {
    if (selectedPujaType != null && selectedDate != null && selectedTimeSlot != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(puja: widget.puja),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final puja = widget.puja;
    final String image = puja['image'] ?? '';
    final String title = puja['title'] ?? '';
    final String price = puja['price'] ?? '';
    final String duration = puja['duration'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(context, image, title),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Price badge sits behind the bottom sheet, tucked
                  /// under its rounded top edge.
                  Positioned(
                    top: -48,
                    right: 18,
                    child: _priceBadge(price),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffF8F5F0),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRail(duration),
                          const SizedBox(height: 22),

                          _sectionTitle("About this Puja"),
                          const SizedBox(height: 8),
                          _aboutSection(),
                          const SizedBox(height: 22),

                          _sectionTitle("Benefits of this Puja"),
                          const SizedBox(height: 12),
                          _benefitsRow(),
                          const SizedBox(height: 22),

                          _sectionTitle("Puja Vidhi"),
                          const SizedBox(height: 12),
                          _pujaVidhiTimeline(),
                          const SizedBox(height: 22),

                          _sectionTitle("Select Puja Type"),
                          const SizedBox(height: 12),
                          _pujaTypeSelector(),
                          const SizedBox(height: 22),

                          _sectionTitle("Select Date"),
                          const SizedBox(height: 12),
                          _dateSelector(),
                          const SizedBox(height: 22),

                          _sectionTitle("Select Time Slot"),
                          const SizedBox(height: 12),
                          _timeSlotSelector(),
                        ],
                      ),
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

  /// ---------------- IMAGE HEADER WITH RADIAL GRADIENT OVERLAY ----------------
  Widget _buildImageHeader(
    BuildContext context,
    String image,
    String title,
  ) {
    return SizedBox(
      height: 380,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// Puja image
          Image.asset(image, fit: BoxFit.cover),

          /// Colour palette radial gradient overlay - image stays visible underneath
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Color(0x4D9D1911),
                  Color(0xFF650E07),
                ],
                stops: [0.53, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          _circleIconButton(
                            icon: isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor: isFavorite
                                ? const Color(0xFFE07A00)
                                : Colors.white,
                            onTap: () =>
                                setState(() => isFavorite = !isFavorite),
                          ),
                          const SizedBox(width: 10),
                          _circleIconButton(
                            icon: Icons.share_outlined,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// Digitally Available badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorResources.kOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Digitally Available",
                      style: avenirNextCyr.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    title,
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFEC94B), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "4.9 (156)",
                        style: avenirNextCyr.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "•",
                        style: avenirNextCyr.copyWith(
                          color: Colors.white70,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "2.4K+ Bookings",
                        style: avenirNextCyr.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
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

  Widget _priceBadge(String price) {
    final priceParts = price.replaceAll('/-', '').trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFE07A00),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "$priceParts/-",
        style: cormorantInfantBold.copyWith(
          color: Colors.white,
          fontSize: Dimensions.fontSizeExtraLarge,
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .2),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  /// ---------------- ICON RAIL ----------------
  Widget _infoRail(String duration) {
    final items = [
      {"icon": "assets/images/Clock.png", "label": "$duration\nDuration"},
      {"icon": "assets/images/Users.png", "label": "Individual or\nFamily"},
      {
        "icon": "assets/images/play_arrow_filled.png",
        "label": "Digitally\nAvailable",
      },
      {"icon": "assets/images/Language.png", "label": "Hindi &\nSanskrit"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 46,
                width: 46,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: _redGradient,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  item['icon']!,
                  height: 20,
                  width: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['label']!,
                textAlign: TextAlign.center,
                style: avenirNextRegular.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return _gradientText(
      title,
      cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
    );
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  /// ---------------- ABOUT ----------------
  Widget _aboutSection() {
    const about =
        "This puja invokes divine blessings for prosperity, beauty and happiness. "
        "Performed by experienced pandits following traditional Vedic rituals, it "
        "brings positivity, harmony and protection to your home and family.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          about,
          maxLines: readMore ? null : 2,
          overflow: readMore ? TextOverflow.visible : TextOverflow.ellipsis,
          style: avenirNextRegular.copyWith(
            color: ColorResources.textLight,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => readMore = !readMore),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _gradientText(
              readMore ? "Read Less" : "Read More",
              avenirNextCyr.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- BENEFITS ----------------
  Widget _benefitsRow() {
    return Row(
      children: benefits.map((b) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffF3D8B3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF4E6),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(b['icon']!, color: ColorResources.kOrange),
                ),
                const SizedBox(height: 8),
                Text(
                  b['title']!,
                  textAlign: TextAlign.center,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// ---------------- PUJA VIDHI TIMELINE ----------------
  Widget _pujaVidhiTimeline() {
    return Column(
      children: List.generate(pujaVidhi.length, (index) {
        final step = pujaVidhi[index];
        final isLast = index == pujaVidhi.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE07A00),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${index + 1}",
                      style: cormorantInfantBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.spacingSize14,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: const Color(0xFFE07A00).withValues(alpha: .3),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']!,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.spacingSize16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step['subtitle']!,
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ---------------- PUJA TYPE ----------------
  Widget _pujaTypeSelector() {
    return Row(
      children: List.generate(pujaTypes.length, (index) {
        final selected = selectedPujaType == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => _selectPujaType(index),
            child: Container(
              margin: EdgeInsets.only(right: index == 0 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                gradient: selected ? _redGradient : null,
                color: selected ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    index == 0 ? Icons.person_outline : Icons.groups_outlined,
                    color: selected ? Colors.white : ColorResources.kOrange,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pujaTypes[index]['title']!,
                    style: cormorantInfantBold.copyWith(
                      color: selected ? Colors.white : ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                  Text(
                    pujaTypes[index]['subtitle']!,
                    style: avenirNextRegular.copyWith(
                      color: selected ? Colors.white70 : ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// ---------------- DATE ----------------
  Widget _dateSelector() {
    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedDate == index;
          return GestureDetector(
            onTap: () => _selectDate(index),
            child: Container(
              width: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: selected ? _redGradient : null,
                color: selected ? null : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]['day']!,
                    style: avenirNextRegular.copyWith(
                      color: selected ? Colors.white70 : ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dates[index]['date']!,
                    style: cormorantInfantBold.copyWith(
                      color: selected ? Colors.white : ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize18,
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

  /// ---------------- TIME SLOT ----------------
  Widget _timeSlotSelector() {
    return Row(
      children: List.generate(timeSlots.length, (index) {
        final selected = selectedTimeSlot == index;
        final slot = timeSlots[index];
        return Expanded(
          child: GestureDetector(
            onTap: () => _selectTimeSlot(index),
            child: Container(
              margin: EdgeInsets.only(right: index == timeSlots.length - 1 ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                gradient: selected ? _redGradient : null,
                color: selected ? null : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    slot['icon'] as IconData,
                    color: selected ? Colors.white : ColorResources.kOrange,
                    size: 18,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slot['title'] as String,
                    style: cormorantInfantBold.copyWith(
                      color: selected ? Colors.white : ColorResources.blackColor,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    slot['time'] as String,
                    textAlign: TextAlign.center,
                    style: avenirNextRegular.copyWith(
                      color: selected ? Colors.white70 : ColorResources.textLight,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

}
