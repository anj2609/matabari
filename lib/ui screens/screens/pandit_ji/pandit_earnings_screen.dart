import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
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
  String selectedStatus = "All Status";
  String selectedSort = "Date (Newest)";

  List<Map<String, String>> _transactions = [];
  bool _loading = true;
  String? _error;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;
  bool _loadingMore = false;

  num? _walletBalance;
  num? _totalEarning;
  num? _pendingAmount;
  bool _loadingStats = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _fetchHistory();
    _scrollController.addListener(_onScroll);
  }

  /// api/pandit/profile already returns wallet_balance alongside
  /// total_earning and pending_amount, so one call covers all 3 stats -
  /// no need to also hit api/pandit/wallet separately here.
  Future<void> _fetchStats() async {
    setState(() => _loadingStats = true);
    try {
      final profileResponse = await ApiClient.getPanditProfile();
      if (!mounted) return;

      num? walletBalance;
      num? totalEarning;
      num? pendingAmount;

      if (profileResponse.statusCode == 200) {
        final body = jsonDecode(profileResponse.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        walletBalance = data?['wallet_balance'] as num?;
        totalEarning = data?['total_earning'] as num?;
        pendingAmount = data?['pending_amount'] as num?;
      }

      setState(() {
        _walletBalance = walletBalance;
        _totalEarning = totalEarning;
        _pendingAmount = pendingAmount;
      });
    } catch (_) {
      // Leave values null - shown as "N/A" rather than fabricated.
    } finally {
      if (mounted) setState(() => _loadingStats = false);
    }
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
      _loadMoreHistory();
    }
  }

  /// Fetches page 1 of wallet history, replacing whatever was loaded before.
  Future<void> _fetchHistory() async {
    setState(() {
      _loading = true;
      _error = null;
      _transactions = [];
      _currentPage = 1;
      _lastPage = 1;
    });

    try {
      final response = await ApiClient.getPanditWalletHistory(page: 1);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final page = body['data'] as Map<String, dynamic>?;
        final list = page?['data'] as List<dynamic>? ?? [];
        setState(() {
          _transactions = list.map((e) => _normalizeTransaction(e as Map<String, dynamic>)).toList();
          _currentPage = page?['current_page'] as int? ?? 1;
          _lastPage = page?['last_page'] as int? ?? 1;
        });
      } else {
        setState(() => _error = body['message'] as String? ?? "Failed to load earnings history.");
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Something went wrong. Please check your connection.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Fetches the next page and appends it - infinite scroll.
  Future<void> _loadMoreHistory() async {
    if (_loadingMore || _currentPage >= _lastPage) return;

    setState(() => _loadingMore = true);
    try {
      final nextPage = _currentPage + 1;
      final response = await ApiClient.getPanditWalletHistory(page: nextPage);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final page = body['data'] as Map<String, dynamic>?;
        final list = page?['data'] as List<dynamic>? ?? [];
        setState(() {
          _transactions.addAll(list.map((e) => _normalizeTransaction(e as Map<String, dynamic>)));
          _currentPage = page?['current_page'] as int? ?? nextPage;
          _lastPage = page?['last_page'] as int? ?? _lastPage;
        });
      }
    } catch (_) {
      // Silently ignore - scrolling again will retry.
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  /// Best-effort mapping for a wallet-history row. api/pandit/wallet/history's
  /// sample response always has an empty `data` array, so the shape of a
  /// real item is unknown - this tries several plausible field names per
  /// value. Replace with exact keys once a real (non-empty) example exists.
  Map<String, String> _normalizeTransaction(Map<String, dynamic> raw) {
    String pick(List<String> keys) {
      for (final k in keys) {
        final v = raw[k];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return '';
    }

    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];

    final rawDate = pick(['date', 'created_at', 'transaction_date', 'createdAt']);
    var dateLabel = rawDate;
    if (rawDate.isNotEmpty) {
      try {
        final d = DateTime.parse(rawDate);
        dateLabel = "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
      } catch (_) {
        dateLabel = rawDate;
      }
    }

    final amount = pick(['amount', 'value', 'total']);
    final type = pick(['type', 'transaction_type', 'status']);
    final title = pick(['title', 'description', 'remark', 'note', 'puja_name']);

    return {
      'title': title.isEmpty ? (type.isEmpty ? 'Transaction' : _capitalize(type)) : title,
      'date': dateLabel,
      'amount': amount,
      'status': type.isEmpty ? '' : _capitalize(type),
    };
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  List<Map<String, String>> get _filtered {
    var list = _transactions
        .where((e) => selectedDate == "All Dates" || e['date'] == selectedDate)
        .where((e) => selectedStatus == "All Status" || e['status'] == selectedStatus)
        .toList();

    list.sort((a, b) {
      switch (selectedSort) {
        case "Name (A-Z)":
          return a['title']!.compareTo(b['title']!);
        case "Amount (Highest)":
          return (double.tryParse(b['amount'] ?? '') ?? 0)
              .compareTo(double.tryParse(a['amount'] ?? '') ?? 0);
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
                            options: [
                              "All Dates",
                              ..._transactions.map((e) => e['date']!).where((d) => d.isNotEmpty).toSet(),
                            ],
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
                                "No earnings match your filters",
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
                                return _transactionRow(results[index]);
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

  /// ---------------- STATS ROW ----------------
  Widget _statsRow() {
    final stats = [
      ("Total Earnings", _totalEarning, "All Time"),
      ("Wallet Balance", _walletBalance, "Available Now"),
      ("Pending Amount", _pendingAmount, "Pending Payout"),
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
                  _loadingStats
                      ? const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            color: Color(0xff9D1911),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          value == null ? "N/A" : "₹$value",
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
                options: [
                  "All Dates",
                  ..._transactions.map((e) => e['date']!).where((d) => d.isNotEmpty).toSet(),
                ],
                selected: selectedDate,
                onSelected: (v) => setState(() => selectedDate = v),
              )),
          const SizedBox(width: 8),
          _filterChip("Status", selectedStatus, () => _pickFilter(
                title: "Filter by Status",
                options: [
                  "All Status",
                  ..._transactions.map((e) => e['status']!).where((s) => s.isNotEmpty).toSet(),
                ],
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

  /// ---------------- TRANSACTION ROW ----------------
  Widget _transactionRow(Map<String, String> e) {
    final status = e['status'] ?? '';
    final isDebit = status.toLowerCase().contains('debit') ||
        status.toLowerCase().contains('withdraw');

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
          Container(
            height: 44,
            width: 44,
            decoration: const BoxDecoration(color: Color(0xFFFFF4E6), shape: BoxShape.circle),
            child: Icon(
              isDebit ? Icons.arrow_upward : Icons.arrow_downward,
              color: isDebit ? Colors.redAccent : const Color(0xFF2E7D32),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['title'] ?? 'Transaction',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                ),
                if ((e['date'] ?? '').isNotEmpty) ...[
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
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${e['amount'] ?? '0'}",
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.kOrange,
                  fontSize: Dimensions.spacingSize16,
                ),
              ),
              if (status.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDebit ? const Color(0xFFE07A00) : const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: cormorantInfantBold.copyWith(color: Colors.white, fontSize: 9),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
