import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/puja_booking_detail_screen.dart';

/// "Bookings" tab of the Pandit dashboard - lists puja bookings with
/// functional status tabs plus date/type/status/sort filtering.
class PujaBookingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PujaBookingsScreen({super.key, required this.onBack});

  @override
  State<PujaBookingsScreen> createState() => _PujaBookingsScreenState();
}

class _PujaBookingsScreenState extends State<PujaBookingsScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  int selectedTab = 0;
  String selectedDate = "All Dates";
  String selectedPujaType = "All Types";
  String selectedStatus = "All Status";
  String selectedSort = "Date (Newest)";

  static const List<Map<String, String>> _bookings = [
    {
      "name": "Rahul Sharma",
      "puja": "Mata Tripura Sundari Puja",
      "status": "Confirmed",
      "category": "upcoming",
      "bookingId": "#PB74391234",
      "date": "25 Jun 2026",
      "time": "09:30 AM",
      "family": "Family (2 Members)",
      "language": "Hindi",
      "image": "assets/images/Rectangle 693.png",
      "phone": "+91 98765 43210",
      "location": "Udaipur, Tripura",
      "amount": "2,500",
      "paidAmount": "2,500",
      "paymentStatus": "Paid",
      "paymentMethod": "Online Payment",
    },
    {
      "name": "Priya Iyer",
      "puja": "Abhishekam Puja",
      "status": "Confirmed",
      "category": "upcoming",
      "bookingId": "#PB74391235",
      "date": "26 Jun 2026",
      "time": "10:00 AM",
      "family": "Family (2 Members)",
      "language": "Sanskrit",
      "image": "assets/images/Rectangle 703.png",
      "phone": "+91 98765 43211",
      "location": "Agartala, Tripura",
      "amount": "1,800",
      "paidAmount": "1,800",
      "paymentStatus": "Paid",
      "paymentMethod": "Online Payment",
    },
    {
      "name": "Amit Verma",
      "puja": "Mangala Aarti Puja",
      "status": "Confirmed",
      "category": "today",
      "bookingId": "#PB74391236",
      "date": "13 Jul 2026",
      "time": "07:00 AM",
      "family": "Family (3 Members)",
      "language": "Hindi",
      "image": "assets/images/Rectangle 720.png",
      "phone": "+91 98765 43212",
      "location": "Udaipur, Tripura",
      "amount": "1,500",
      "paidAmount": "1,500",
      "paymentStatus": "Paid",
      "paymentMethod": "Online Payment",
    },
    {
      "name": "Sneha Patel",
      "puja": "Durga Saptashati Path",
      "status": "Completed",
      "category": "completed",
      "bookingId": "#PB74391237",
      "date": "15 May 2026",
      "time": "08:00 AM",
      "family": "Family (2 Members)",
      "language": "Bengali",
      "image": "assets/images/Rectangle 725.png",
      "phone": "+91 98765 43213",
      "location": "Udaipur, Tripura",
      "amount": "3,000",
      "paidAmount": "3,000",
      "paymentStatus": "Paid",
      "paymentMethod": "Online Payment",
    },
    {
      "name": "Vikram Singh",
      "puja": "Laxmi Puja",
      "status": "Confirmed",
      "category": "upcoming",
      "bookingId": "#PB74391238",
      "date": "28 Jun 2026",
      "time": "11:00 AM",
      "family": "Family (4 Members)",
      "language": "Punjabi",
      "image": "assets/images/Rectangle 708.png",
      "phone": "+91 98765 43214",
      "location": "Udaipur, Tripura",
      "amount": "2,200",
      "paidAmount": "2,200",
      "paymentStatus": "Paid",
      "paymentMethod": "Online Payment",
    },
    {
      "name": "Karan Mehta",
      "puja": "Ganesh Puja",
      "status": "Cancelled",
      "category": "cancelled",
      "bookingId": "#PB74391239",
      "date": "20 Jun 2026",
      "time": "06:00 PM",
      "family": "Family (3 Members)",
      "language": "Hindi",
      "image": "assets/images/Rectangle 725.png",
      "phone": "+91 98765 43215",
      "location": "Udaipur, Tripura",
      "amount": "1,200",
      "paidAmount": "0",
      "paymentStatus": "Refunded",
      "paymentMethod": "Online Payment",
    },
  ];

  static const _tabs = ["Upcoming", "Today", "Completed", "Cancelled"];
  static const _tabCategories = ["upcoming", "today", "completed", "cancelled"];

  List<Map<String, String>> get _filtered {
    var list = _bookings
        .where((b) => b['category'] == _tabCategories[selectedTab])
        .where((b) => selectedDate == "All Dates" || b['date'] == selectedDate)
        .where((b) => selectedPujaType == "All Types" || b['puja'] == selectedPujaType)
        .where((b) => selectedStatus == "All Status" || b['status'] == selectedStatus)
        .toList();

    list.sort((a, b) {
      switch (selectedSort) {
        case "Name (A-Z)":
          return a['name']!.compareTo(b['name']!);
        case "Date (Oldest)":
          return a['date']!.compareTo(b['date']!);
        default:
          return b['date']!.compareTo(a['date']!);
      }
    });
    return list;
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF2E7D32);
      case "Cancelled":
        return Colors.redAccent;
      default:
        return const Color(0xFFE07A00);
    }
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
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: .2),
                          ),
                          child: const Icon(Icons.ios_share, color: Colors.white, size: 15),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: const Alignment(0, -0.5),
                        child: Text(
                          "Puja Bookings",
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
                    _tabRow(),
                    const SizedBox(height: 12),
                    _filterRow(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: results.isEmpty
                          ? Center(
                              child: Text(
                                "No bookings match your filters",
                                style: avenirNextRegular.copyWith(
                                  color: ColorResources.textLight,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: results.length,
                              itemBuilder: (context, index) => _bookingCard(results[index]),
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

  /// ---------------- STATUS TABS ----------------
  Widget _tabRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final active = selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedTab = i),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: active ? _redGradient : null,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    _tabs[i],
                    style: cormorantInfantBold.copyWith(
                      color: active ? Colors.white : ColorResources.textLight,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
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
                options: ["All Dates", ..._bookings.map((b) => b['date']!).toSet()],
                selected: selectedDate,
                onSelected: (v) => setState(() => selectedDate = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Puja Type", selectedPujaType, () => _pickFilter(
                title: "Filter by Puja Type",
                options: ["All Types", ..._bookings.map((b) => b['puja']!).toSet()],
                selected: selectedPujaType,
                onSelected: (v) => setState(() => selectedPujaType = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Status", selectedStatus, () => _pickFilter(
                title: "Filter by Status",
                options: ["All Status", ..._bookings.map((b) => b['status']!).toSet()],
                selected: selectedStatus,
                onSelected: (v) => setState(() => selectedStatus = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Sort", selectedSort, () => _pickFilter(
                title: "Sort by",
                options: const ["Date (Newest)", "Date (Oldest)", "Name (A-Z)"],
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

  /// ---------------- BOOKING CARD ----------------
  Widget _bookingCard(Map<String, String> b) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PujaBookingDetailScreen(booking: b)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              child: Image.asset(b['image']!, height: 64, width: 64, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                b['name']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: cormorantInfantBold.copyWith(
                                  color: ColorResources.blackColor,
                                  fontSize: Dimensions.spacingSize16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: Color(0xff2563EB), size: 13),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _statusColor(b['status']!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          b['status']!,
                          style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    b['puja']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  Text(
                    "Booking ID: ${b['bookingId']}",
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        b['date']!,
                        style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        b['time']!,
                        style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.people_alt_outlined, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        b['family']!,
                        style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.language, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        b['language']!,
                        style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 30,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: _redGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "View Details",
                      style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 12),
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
}
