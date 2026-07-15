import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
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

  List<Map<String, String>> _bookings = [];
  bool _loading = true;
  String? _error;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;
  bool _loadingMore = false;

  static const _tabs = ["Upcoming", "Today", "Completed"];
  static const _tabCategories = ["upcoming", "today", "completed"];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loading || _loadingMore) return;
    if (_currentPage >= _lastPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreBookings();
    }
  }

  /// Fetches page 1 for the currently selected tab, replacing whatever was
  /// previously loaded.
  Future<void> _fetchBookings() async {
    setState(() {
      _loading = true;
      _error = null;
      _bookings = [];
      _currentPage = 1;
      _lastPage = 1;
    });

    try {
      final response = await ApiClient.getPanditBookings(_tabCategories[selectedTab], page: 1);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final page = body['data'] as Map<String, dynamic>?;
        final list = page?['data'] as List<dynamic>? ?? [];
        setState(() {
          _bookings = list.map((e) => _normalize(e as Map<String, dynamic>)).toList();
          _currentPage = page?['current_page'] as int? ?? 1;
          _lastPage = page?['last_page'] as int? ?? 1;
        });
      } else {
        setState(() => _error = body['message'] as String? ?? "Failed to load bookings.");
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Something went wrong. Please check your connection.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Fetches the next page and appends it - triggered by scrolling near
  /// the bottom of the list (infinite scroll).
  Future<void> _loadMoreBookings() async {
    if (_loadingMore || _currentPage >= _lastPage) return;

    setState(() => _loadingMore = true);
    try {
      final nextPage = _currentPage + 1;
      final response = await ApiClient.getPanditBookings(
        _tabCategories[selectedTab],
        page: nextPage,
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final page = body['data'] as Map<String, dynamic>?;
        final list = page?['data'] as List<dynamic>? ?? [];
        setState(() {
          _bookings.addAll(list.map((e) => _normalize(e as Map<String, dynamic>)));
          _currentPage = page?['current_page'] as int? ?? nextPage;
          _lastPage = page?['last_page'] as int? ?? _lastPage;
        });
      }
    } catch (_) {
      // Silently ignore - scrolling again (or switching tabs) will retry.
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  /// Maps a raw api/pandit/bookings item onto the field names this screen
  /// (and the booking detail screen) already use. Fields the API doesn't
  /// provide (time, language, location, payment/sankalp/inclusions info)
  /// are simply left out - callers already fall back gracefully for those.
  Map<String, String> _normalize(Map<String, dynamic> raw) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];

    var dateLabel = '';
    final rawDate = raw['booking_date'] as String?;
    if (rawDate != null) {
      try {
        final parsed = DateTime.parse(rawDate);
        dateLabel =
            "${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}";
      } catch (_) {
        dateLabel = rawDate;
      }
    }

    final isSelf = raw['is_self'] == true;
    final memberCount = raw['member_count'] as int? ?? 0;
    final familyLabel = isSelf
        ? "Self"
        : "Family ($memberCount Member${memberCount == 1 ? '' : 's'})";

    final status = (raw['status'] as String? ?? '').trim();
    final statusLabel = status.isEmpty ? '' : status[0].toUpperCase() + status.substring(1);

    return {
      'id': raw['booking_id']?.toString() ?? '',
      'name': raw['devotee_name'] as String? ?? '',
      'puja': raw['puja_name'] as String? ?? '',
      'status': statusLabel,
      'bookingId': raw['booking_no'] as String? ?? '',
      'date': dateLabel,
      'family': familyLabel,
      'image': raw['thumbnail'] as String? ?? '',
      'phone': raw['phone'] as String? ?? '',
    };
  }

  List<Map<String, String>> get _filtered {
    var list = _bookings
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
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff9D1911),
                                strokeWidth: 2,
                              ),
                            )
                          : _error != null
                          ? Center(
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: avenirNextRegular.copyWith(
                                  color: ColorResources.textLight,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            )
                          : results.isEmpty
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
                              controller: _scrollController,
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: results.length + (_loadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= results.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xff9D1911),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                                return _bookingCard(results[index]);
                              },
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
                onTap: () {
                  if (selectedTab == i) return;
                  setState(() => selectedTab = i);
                  if (_scrollController.hasClients) _scrollController.jumpTo(0);
                  _fetchBookings();
                },
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
      onTap: () {
        final id = int.tryParse(b['id'] ?? '');
        if (id == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PujaBookingDetailScreen(bookingId: id)),
        );
      },
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
              child: (b['image'] ?? '').startsWith('http')
                  ? Image.network(
                      b['image']!,
                      height: 64,
                      width: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 64,
                        width: 64,
                        color: const Color(0xFFFFF4E6),
                        child: const Icon(Icons.image_not_supported_outlined, color: ColorResources.kOrange),
                      ),
                    )
                  : Image.asset(
                      (b['image'] ?? '').isEmpty ? 'assets/images/Rectangle 693.png' : b['image']!,
                      height: 64,
                      width: 64,
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
                        b['date'] ?? '',
                        style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                      ),
                      if ((b['time'] ?? '').isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time, size: 11, color: Color(0xffF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                          b['time']!,
                          style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.people_alt_outlined, size: 11, color: Color(0xffF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        b['family'] ?? '',
                        style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                      ),
                      if ((b['language'] ?? '').isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.language, size: 11, color: Color(0xffF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                          b['language']!,
                          style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 10),
                        ),
                      ],
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
