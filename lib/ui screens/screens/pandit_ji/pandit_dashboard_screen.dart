import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/pandit_earnings_screen.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/pandit_profile_screen.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/puja_booking_detail_screen.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/puja_bookings_screen.dart';
import 'package:matabari/widgets/pandit_bottom_nav.dart';

/// Dashboard shown to a Pandit Ji after completing registration.
class PanditDashboardScreen extends StatefulWidget {
  const PanditDashboardScreen({super.key});

  @override
  State<PanditDashboardScreen> createState() => _PanditDashboardScreenState();
}

class _PanditDashboardScreenState extends State<PanditDashboardScreen> {
  int currentIndex = 0;
  String panditName = "Pandit Ji";

  static const _tabTitles = ["Dashboard", "Bookings", "Earning", "My Profile"];

  @override
  void initState() {
    super.initState();
    _loadPanditName();
  }

  Future<void> _loadPanditName() async {
    final name = await SessionPrefs.getUserName();
    if (!mounted || name == null || name.isEmpty) return;
    setState(() => panditName = name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      body: SafeArea(
        top: currentIndex != 1 && currentIndex != 2,
        child: switch (currentIndex) {
          0 => _PanditHomeTab(name: panditName),
          1 => PujaBookingsScreen(onBack: () => setState(() => currentIndex = 0)),
          2 => PanditEarningsScreen(onBack: () => setState(() => currentIndex = 0)),
          3 => const PanditProfileScreen(),
          _ => _ComingSoonTab(title: _tabTitles[currentIndex]),
        },
      ),
      bottomNavigationBar: PanditBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}

class _PanditHomeTab extends StatefulWidget {
  final String name;

  const _PanditHomeTab({required this.name});

  @override
  State<_PanditHomeTab> createState() => _PanditHomeTabState();
}

class _PanditHomeTabState extends State<_PanditHomeTab> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  bool _loadingTodayPuja = true;
  int? _todayCount;
  int _todayCompleted = 0;
  int _todayNotCompleted = 0;

  bool _loadingEarning = true;
  num? _totalEarning;
  num? _pendingAmount;

  bool _loadingSchedule = true;
  bool _loadingMoreSchedule = false;
  List<Map<String, String>> _upcomingSchedule = [];
  int _schedulePage = 1;
  int _scheduleLastPage = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchTodayPuja();
    _fetchEarnings();
    _fetchUpcomingSchedule();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingSchedule || _loadingMoreSchedule) return;
    if (_schedulePage >= _scheduleLastPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreSchedule();
    }
  }

  /// Count + Completed/Upcoming breakdown for today's pujas, from
  /// api/pandit/bookings?status=today. Walks every page (today's booking
  /// count is small in practice) so the breakdown reflects all of them,
  /// not just the first page - capped at 20 pages as a safety limit.
  Future<void> _fetchTodayPuja() async {
    setState(() => _loadingTodayPuja = true);
    try {
      var total = 0;
      var completed = 0;
      var fetchedCount = 0;
      var page = 1;
      var lastPage = 1;

      do {
        final response = await ApiClient.getPanditBookings('today', page: page);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (response.statusCode != 200) break;

        final pageData = body['data'] as Map<String, dynamic>?;
        final list = (pageData?['data'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        total = pageData?['total'] as int? ?? list.length;
        lastPage = pageData?['last_page'] as int? ?? 1;

        completed += list
            .where((b) => (b['status'] as String? ?? '').toLowerCase() == 'completed')
            .length;
        fetchedCount += list.length;

        page++;
      } while (page <= lastPage && page <= 20);

      if (!mounted) return;
      setState(() {
        _todayCount = total;
        _todayCompleted = completed;
        _todayNotCompleted = fetchedCount - completed;
      });
    } catch (_) {
      // Leave values null - shown as "N/A" rather than fabricated.
    } finally {
      if (mounted) setState(() => _loadingTodayPuja = false);
    }
  }

  /// Total Earning + the Paid/Pending breakdown, from
  /// api/pandit/profile's total_earning/pending_amount fields.
  Future<void> _fetchEarnings() async {
    setState(() => _loadingEarning = true);
    try {
      final response = await ApiClient.getPanditProfile();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = body['data'] as Map<String, dynamic>?;
        setState(() {
          _totalEarning = data?['total_earning'] as num?;
          _pendingAmount = data?['pending_amount'] as num?;
        });
      }
    } catch (_) {
      // Leave values null - shown as "N/A" rather than fabricated.
    } finally {
      if (mounted) setState(() => _loadingEarning = false);
    }
  }

  /// Fetches page 1, replacing whatever was loaded before.
  Future<void> _fetchUpcomingSchedule() async {
    setState(() {
      _loadingSchedule = true;
      _upcomingSchedule = [];
      _schedulePage = 1;
      _scheduleLastPage = 1;
    });
    try {
      final response = await ApiClient.getPanditBookings('upcoming', page: 1);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final page = body['data'] as Map<String, dynamic>?;
        final list = page?['data'] as List<dynamic>? ?? [];
        setState(() {
          _upcomingSchedule =
              list.map((e) => _normalizeSchedule(e as Map<String, dynamic>)).toList();
          _schedulePage = page?['current_page'] as int? ?? 1;
          _scheduleLastPage = page?['last_page'] as int? ?? 1;
        });
      }
    } catch (_) {
      // Leave list empty - shown as "No upcoming pujas scheduled".
    } finally {
      if (mounted) setState(() => _loadingSchedule = false);
    }
  }

  /// Fetches the next page and appends it - infinite scroll.
  Future<void> _loadMoreSchedule() async {
    if (_loadingMoreSchedule || _schedulePage >= _scheduleLastPage) return;

    setState(() => _loadingMoreSchedule = true);
    try {
      final nextPage = _schedulePage + 1;
      final response = await ApiClient.getPanditBookings('upcoming', page: nextPage);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final page = body['data'] as Map<String, dynamic>?;
        final list = page?['data'] as List<dynamic>? ?? [];
        setState(() {
          _upcomingSchedule.addAll(
            list.map((e) => _normalizeSchedule(e as Map<String, dynamic>)),
          );
          _schedulePage = page?['current_page'] as int? ?? nextPage;
          _scheduleLastPage = page?['last_page'] as int? ?? _scheduleLastPage;
        });
      }
    } catch (_) {
      // Silently ignore - scrolling again will retry.
    } finally {
      if (mounted) setState(() => _loadingMoreSchedule = false);
    }
  }

  /// Maps a raw api/pandit/bookings item onto what the schedule card needs.
  /// The API doesn't provide a time-of-day, so 'time' is left out and the
  /// card hides that part rather than showing a blank/"null" value.
  Map<String, String> _normalizeSchedule(Map<String, dynamic> raw) {
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

    return {
      'id': raw['booking_id']?.toString() ?? '',
      'title': raw['puja_name'] as String? ?? '',
      'date': dateLabel,
      'family': familyLabel,
      'image': raw['thumbnail'] as String? ?? '',
    };
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: _header(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _heroBanner(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _statsRow(),
          ),
          const SizedBox(height: 22),

          _sectionTitle("Quick Overview"),
          const SizedBox(height: 10),
          _quickOverviewRow(),
          const SizedBox(height: 22),

          _sectionHeader("Upcoming Schedule"),
          const SizedBox(height: 10),
          if (_loadingSchedule)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xff9D1911), strokeWidth: 2),
              ),
            )
          else if (_upcomingSchedule.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                "No upcoming pujas scheduled",
                style: avenirNextRegular.copyWith(
                  color: ColorResources.textLight,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            )
          else ...[
            ..._upcomingSchedule.map(_scheduleCard),
            if (_loadingMoreSchedule)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xff9D1911), strokeWidth: 2),
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header() {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: ColorResources.kOrange.withValues(alpha: .16),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffF3D8B3)),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: ColorResources.kOrange,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _gradientText(
                "Jai Maa Tripura Sundari",
                cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize16),
              ),
              Text(
                "Welcome, ${widget.name}",
                style: avenirNextRegular.copyWith(
                  color: ColorResources.textLight,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xff9D1911),
                size: 18,
              ),
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFE07A00),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ---------------- HERO BANNER ----------------
  Widget _heroBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 130,
            width: double.infinity,
            child: Image.asset("assets/images/image 29.png", fit: BoxFit.cover),
          ),
          Container(
            height: 130,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xF2FFF8ED), Color(0x00FFF8ED)],
                stops: [0.0, 0.85],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _gradientText(
                  "Guiding Devotees\nThrough Faith",
                  cormorantInfantBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
                const SizedBox(height: 6),
                Text(
                  "Organize your pujas\nand continue the sacred tradition\nwith ease.",
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- STATS ROW ----------------
  Widget _statsRow() {
    final paid = (_totalEarning != null && _pendingAmount != null)
        ? (_totalEarning! - _pendingAmount!)
        : null;

    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.self_improvement,
            label: "Today's Puja",
            value: _loadingTodayPuja
                ? "…"
                : (_todayCount == null ? "N/A" : _todayCount.toString().padLeft(2, '0')),
            sub: _loadingTodayPuja
                ? "Loading..."
                : (_todayCount == null
                    ? "N/A"
                    : "$_todayCompleted Completed | $_todayNotCompleted Upcoming"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.currency_rupee,
            label: "Total Earning",
            value: _loadingEarning
                ? "…"
                : (_totalEarning == null ? "N/A" : "₹$_totalEarning"),
            sub: _loadingEarning
                ? "Loading..."
                : (paid == null || _pendingAmount == null
                    ? "N/A"
                    : "Paid ₹$paid | Pending ₹$_pendingAmount"),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4E6),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: ColorResources.kOrange, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: cormorantInfantBold.copyWith(
              color: ColorResources.blackColor,
              fontSize: Dimensions.fontSizeExtraLarge,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: avenirNextRegular.copyWith(
              color: const Color(0xff9D1911),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: _gradientText(
        title,
        cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
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

  /// ---------------- QUICK OVERVIEW ----------------
  Widget _quickOverviewRow() {
    final stats = [
      (Icons.pending_actions_outlined, "Pending Pujas", "05"),
      (Icons.check_circle_outline, "Completed Pujas", "03"),
      (Icons.event_available_outlined, "Upcoming Pujas", "07"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: stats.map((s) {
          final (icon, label, value) = s;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF4E6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: ColorResources.kOrange, size: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: cormorantInfantBold.copyWith(
                      color: const Color(0xff9D1911),
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
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

  /// ---------------- SCHEDULE CARD ----------------
  Widget _scheduleCard(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
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
              child: (item['image'] ?? '').startsWith('http')
                  ? Image.network(
                      item['image']!,
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
                      (item['image'] ?? '').isEmpty
                          ? 'assets/images/Rectangle 693.png'
                          : item['image']!,
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
                        child: Text(
                          item['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: Dimensions.spacingSize16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE07A00),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Upcoming",
                          style: cormorantInfantBold.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 11,
                        color: Color(0xffF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['date'] ?? '',
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 11,
                        ),
                      ),
                      if ((item['time'] ?? '').isNotEmpty) ...[
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.access_time,
                          size: 11,
                          color: Color(0xffF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['time']!,
                          style: avenirNextRegular.copyWith(
                            color: ColorResources.textLight,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        size: 11,
                        color: Color(0xffF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['family']!,
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      final id = int.tryParse(item['id'] ?? '');
                      if (id == null) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PujaBookingDetailScreen(bookingId: id),
                        ),
                      );
                    },
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: _redGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "View Details",
                        style: cormorantInfantBold.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
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
}

class _ComingSoonTab extends StatelessWidget {
  final String title;

  const _ComingSoonTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$title — coming soon",
        style: avenirNextCyr.copyWith(
          color: ColorResources.textLight,
          fontSize: 14,
        ),
      ),
    );
  }
}
