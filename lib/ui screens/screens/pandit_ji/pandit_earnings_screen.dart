import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

/// "Earning" tab of the Pandit dashboard - matches the layout pattern used
/// by the devotee Puja tab: a flat header image with a rounded-top sheet
/// overlapping it, rather than a fully rounded banner.
class PanditEarningsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PanditEarningsScreen({super.key, required this.onBack});

  @override
  State<PanditEarningsScreen> createState() => _PanditEarningsScreenState();
}

class _PanditEarningsScreenState extends State<PanditEarningsScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  String selectedDate = "All Dates";
  String selectedPujaType = "All Types";
  String selectedStatus = "All Status";
  String selectedSort = "Date (Newest)";

  static const List<Map<String, String>> _earnings = [
    {
      "title": "Maa Tripura Sundari Puja",
      "date": "25 Jun 2026",
      "amount": "2500",
      "status": "Paid",
      "image": "assets/images/Rectangle 693.png",
    },
    {
      "title": "Rudrabhishek",
      "date": "23 Jun 2026",
      "amount": "3000",
      "status": "Paid",
      "image": "assets/images/Rectangle 703.png",
    },
    {
      "title": "Navgraha Shanti Puja",
      "date": "20 Jun 2026",
      "amount": "2000",
      "status": "Paid",
      "image": "assets/images/Rectangle 720.png",
    },
    {
      "title": "Durga Saptashati Path",
      "date": "15 Jun 2026",
      "amount": "1500",
      "status": "Paid",
      "image": "assets/images/Rectangle 725.png",
    },
    {
      "title": "Laxmi Puja",
      "date": "12 Jun 2026",
      "amount": "2000",
      "status": "Pending",
      "image": "assets/images/Rectangle 708.png",
    },
  ];

  List<Map<String, String>> get _filtered {
    var list = _earnings
        .where((e) => selectedDate == "All Dates" || e['date'] == selectedDate)
        .where((e) => selectedPujaType == "All Types" || e['title'] == selectedPujaType)
        .where((e) => selectedStatus == "All Status" || e['status'] == selectedStatus)
        .toList();

    list.sort((a, b) {
      switch (selectedSort) {
        case "Name (A-Z)":
          return a['title']!.compareTo(b['title']!);
        case "Amount (Highest)":
          return int.parse(b['amount']!).compareTo(int.parse(a['amount']!));
        case "Date (Oldest)":
          return a['date']!.compareTo(b['date']!);
        default:
          return b['date']!.compareTo(a['date']!);
      }
    });
    return list;
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return SafeArea(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onBack,
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
                        GestureDetector(
                          onTap: () => _pickFilter(
                            title: "Filter by Date",
                            options: ["All Dates", ..._earnings.map((e) => e['date']!).toSet()],
                            selected: selectedDate,
                            onSelected: (v) => setState(() => selectedDate = v),
                          ),
                          child: Container(
                            height: 34,
                            width: 34,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: .2),
                            ),
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                              child: Image.asset('assets/images/Calendar.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: const Alignment(0, -0.5),
                        child: Text(
                          "Earnings",
                          style: cormorantInfantBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.spacingSize22,
                          ),
                        ),
                      ),
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
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    _statsRow(),
                    const SizedBox(height: 20),
                    _sectionHeader(),
                    const SizedBox(height: 12),
                    _filterRow(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: results.isEmpty
                          ? Center(
                              child: Text(
                                "No earnings match your filters",
                                style: avenirNextRegular.copyWith(
                                  color: ColorResources.textLight,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: results.length,
                              itemBuilder: (context, index) => _earningRow(results[index]),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- STATS ROW ----------------
  Widget _statsRow() {
    final stats = [
      ("Total Earnings", "₹85,000", "All Time"),
      ("Paid Amount", "₹60,000", "This Month"),
      ("Pending Amount", "₹25,000", "Pending Payout"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: stats.map((s) {
          final (label, value, sub) = s;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: cormorantInfantBold.copyWith(
                      color: const Color(0xff9D1911),
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
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

  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _gradientText(
            "Earnings History",
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _notify("Downloading earnings report..."),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.file_download_outlined, size: 14, color: Color(0xFFE07A00)),
                const SizedBox(width: 4),
                Text(
                  "Download Report",
                  style: avenirNextCyr.copyWith(
                    color: const Color(0xFFE07A00),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- FILTER ROW ----------------
  Widget _filterRow() {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip("Date", selectedDate, () => _pickFilter(
                title: "Filter by Date",
                options: ["All Dates", ..._earnings.map((e) => e['date']!).toSet()],
                selected: selectedDate,
                onSelected: (v) => setState(() => selectedDate = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Puja Type", selectedPujaType, () => _pickFilter(
                title: "Filter by Puja Type",
                options: ["All Types", ..._earnings.map((e) => e['title']!).toSet()],
                selected: selectedPujaType,
                onSelected: (v) => setState(() => selectedPujaType = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Payment Status", selectedStatus, () => _pickFilter(
                title: "Filter by Payment Status",
                options: ["All Status", ..._earnings.map((e) => e['status']!).toSet()],
                selected: selectedStatus,
                onSelected: (v) => setState(() => selectedStatus = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Sort", selectedSort, () => _pickFilter(
                title: "Sort by",
                options: const [
                  "Date (Newest)",
                  "Date (Oldest)",
                  "Amount (Highest)",
                  "Name (A-Z)",
                ],
                selected: selectedSort,
                onSelected: (v) => setState(() => selectedSort = v),
              )),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value, VoidCallback onTap) {
    final active = !value.startsWith("All") && !value.startsWith("Date (Newest)");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF4E6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: cormorantInfantBold.copyWith(
                color: active ? const Color(0xff9D1911) : ColorResources.blackColor,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: active ? const Color(0xff9D1911) : ColorResources.textLight,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFilter({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xffF8F5F0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ),
              ),
              ...options.map(
                (o) => ListTile(
                  title: Text(
                    o,
                    style: cormorantInfantBold.copyWith(
                      color: o == selected
                          ? const Color(0xff9D1911)
                          : ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                  trailing: o == selected
                      ? const Icon(Icons.check, color: Color(0xff9D1911))
                      : null,
                  onTap: () => Navigator.pop(sheetContext, o),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (choice != null) onSelected(choice);
  }

  /// ---------------- EARNING ROW ----------------
  Widget _earningRow(Map<String, String> e) {
    final isPaid = e['status'] == 'Paid';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(e['image']!, height: 52, width: 52, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 11, color: Color(0xffF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      e['date']!,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${e['amount']}",
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.kOrange,
                  fontSize: Dimensions.spacingSize16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPaid ? const Color(0xFF2E7D32) : const Color(0xFFE07A00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  e['status']!,
                  style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
