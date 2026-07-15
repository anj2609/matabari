import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';

/// "My Profile" tab of the Pandit dashboard - about, specialization,
/// language and bank details.
class PanditProfileScreen extends StatefulWidget {
  const PanditProfileScreen({super.key});

  @override
  State<PanditProfileScreen> createState() => _PanditProfileScreenState();
}

class _PanditProfileScreenState extends State<PanditProfileScreen> {
  static const _defaultSpecializations = [
    "Mata Tripura Sundari Puja",
    "Rudrabhishek",
    "Navagraha Shanti",
    "Durga Saptashati Puja",
    "Grah Shanti Puja",
    "Satyanarayan Katha",
  ];

  static const _defaultLanguages = ["Hindi", "English", "Sanskrit", "Bhojpuri"];

  static TextStyle get _sectionTitleStyle => cormorantInfantBold.copyWith(
    color: ColorResources.textDark,
    fontSize: 14,
  );

  Map<String, dynamic>? _profile;
  bool _loading = true;

  Map<String, dynamic>? _bankInfo;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchBankInfo();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await ApiClient.getPanditProfile();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _profile = body['data'] as Map<String, dynamic>?);
      }
    } catch (_) {
      // Non-critical - screen falls back to static placeholder content.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchBankInfo() async {
    try {
      final response = await ApiClient.getBankInfo();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _bankInfo = body['data'] as Map<String, dynamic>?);
      }
    } catch (_) {
      // Non-critical - screen falls back to static placeholder content.
    }
  }

  /// Splits a comma-separated field into trimmed chips. Also strips stray
  /// literal quote characters - the API's `skill` field currently comes
  /// back as the string `"\"Skill1, Skill2\""` (quotes baked into the
  /// value itself), which this cleans up.
  List<String> _splitList(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final cleaned = raw.replaceAll('"', '').trim();
    if (cleaned.isEmpty) return [];
    return cleaned.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  String _formatDob(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso);
      const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
      ];
      return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final specializations = _splitList(_profile?['skill'] as String?);
    final languages = _splitList(_profile?['language'] as String?);
    final gender = _profile?['gender'] as String?;
    final dob = _formatDob(_profile?['dob'] as String?);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileCard(),
          const SizedBox(height: 22),
          _earningsSnapshotRow(),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("About me", "Edit"),
          const SizedBox(height: 10),
          _aboutCard(),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("Specialization", "Edit"),
          const SizedBox(height: 10),
          _chipsCard(specializations.isEmpty ? _defaultSpecializations : specializations),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("Language", "Edit"),
          const SizedBox(height: 10),
          _chipsCard(languages.isEmpty ? _defaultLanguages : languages),
          const SizedBox(height: 22),
          if (gender != null || dob.isNotEmpty) ...[
            _sectionHeaderWithAction("Personal Details", "Edit"),
            const SizedBox(height: 10),
            _detailsCard([
              if (gender != null) ("Gender", gender[0].toUpperCase() + gender.substring(1)),
              if (dob.isNotEmpty) ("Date of Birth", dob),
            ]),
            const SizedBox(height: 22),
          ],
          _sectionHeaderWithAction("Bank Details", "Edit"),
          const SizedBox(height: 10),
          _bankCard(),
          const SizedBox(height: 14),
          _accountActionsCard(context),
        ],
      ),
    );
  }

  Widget _cardDecoration({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double radius = 20,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorResources.cardBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: ColorResources.border, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: ColorResources.secondary.withValues(alpha: 0.45),
            blurRadius: 8,
            spreadRadius: -1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorResources.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorResources.border, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: ColorResources.secondary.withValues(alpha: 0.45),
            blurRadius: 8,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile icon only - no photo.
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorResources.kOrange.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorResources.kGold, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: ColorResources.kOrange,
                  size: 32,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: ColorResources.kOrange,
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "4.8 Ratings",
                        style: avenirNextCyr.copyWith(
                          color: ColorResources.textDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColorResources.kOrange),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            color: ColorResources.kOrange,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Edit Profile",
                            style: avenirNextCyr.copyWith(
                              color: ColorResources.kOrange,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: Text(
                  _profile?['name'] as String? ?? "Pandit Rajesh Sharma",
                  overflow: TextOverflow.ellipsis,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.textDark,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Color(0xFF3B9EEF), size: 15),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.call_rounded,
                color: ColorResources.kOrange,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                _profile?['phone'] as String? ?? "+91 987-654-3210",
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textLight,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.mail_outline_rounded,
                color: ColorResources.kOrange,
                size: 12,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _profile?['email'] as String? ?? "panditrajesh@gmail.com",
                  overflow: TextOverflow.ellipsis,
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.textLight,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- EARNINGS SNAPSHOT ----------------
  Widget _earningsSnapshotRow() {
    final wallet = _profile?['wallet_balance'];
    final totalEarning = _profile?['total_earning'];
    final pending = _profile?['pending_amount'];

    final stats = [
      ("Wallet Balance", wallet),
      ("Total Earning", totalEarning),
      ("Pending Amount", pending),
    ];

    return Row(
      children: stats.map((s) {
        final (label, value) = s;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: ColorResources.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorResources.border, width: 1.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: avenirNextCyr.copyWith(color: ColorResources.textLight, fontSize: 9),
                ),
                const SizedBox(height: 6),
                _loading
                    ? const SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                          color: ColorResources.kOrange,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        value == null ? "N/A" : "₹$value",
                        style: cormorantInfantBold.copyWith(
                          color: const Color(0xff9D1911),
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionHeaderWithAction(String title, String actionLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: _sectionTitleStyle),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.edit_outlined,
              color: ColorResources.kOrange,
              size: 12,
            ),
            const SizedBox(width: 3),
            Text(
              actionLabel,
              style: avenirNextCyr.copyWith(
                color: ColorResources.kOrange,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _aboutCard() {
    return _cardDecoration(
      padding: const EdgeInsets.all(16),
      child: Text(
        "I have been performing pujas and rituals for over 8 years with "
        "devotion and dedication. My aim is to help devotees reconnect with "
        "divine blessings and bring peace and happiness into their lives.",
        style: avenirNextCyr.copyWith(
          color: ColorResources.textLight,
          fontSize: 11,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: ColorResources.kOrange.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorResources.kGold.withValues(alpha: .6)),
      ),
      child: Text(
        label,
        style: avenirNextCyr.copyWith(
          color: ColorResources.textDark,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _chipsCard(List<String> items) {
    return _cardDecoration(
      padding: const EdgeInsets.all(18),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map(_chip).toList(),
      ),
    );
  }

  Widget _detailsCard(List<(String, String)> items) {
    return _cardDecoration(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i != 0) const SizedBox(height: 12),
            _detailRow(items[i]),
          ],
        ],
      ),
    );
  }

  Widget _detailRow((String, String) item) {
    final (label, value) = item;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textLight,
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: avenirNextCyr.copyWith(
              color: ColorResources.textDark,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bankCard() {
    final bankName = _bankInfo?['bank_name'] as String? ?? "State Bank of India";
    final holderName = _bankInfo?['holder_name'] as String? ?? "Rajesh Sharma";
    final acNo = _bankInfo?['ac_no'] as String? ?? "1234 5678 9012";
    final ifscCode = _bankInfo?['ifsc_code'] as String? ?? "SBIN0001234";

    return _cardDecoration(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/Ellipse 92.png',
                width: 38,
                height: 38,
              ),
              const SizedBox(width: 10),
              Text(
                bankName,
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bankInfoRow("Name: $holderName", "A/C No: $acNo"),
          const SizedBox(height: 8),
          _bankInfoRow("IFSC: $ifscCode", ""),
        ],
      ),
    );
  }

  Widget _bankInfoRow(String left, String right) {
    final style = avenirNextCyr.copyWith(
      color: ColorResources.textLight,
      fontSize: 9,
    );
    return Row(
      children: [
        Expanded(child: Text(left, style: style)),
        Expanded(
          child: Text(right, style: style, textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Widget _accountActionsCard(BuildContext context) {
    return _cardDecoration(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: Column(
        children: [
          _actionRow(
            icon: 'assets/images/Headphones.png',
            title: "Logout",
            subtitle: "Sign out from your account",
            onTap: () => _confirmLogout(context),
          ),
          _thinHorizontalDivider(),
          _actionRow(
            icon: 'assets/images/Shield.png',
            title: "Delete Account",
            subtitle: "Permanently delete your account & all data",
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ),
    );
  }

  Widget _thinHorizontalDivider() {
    return Container(
      height: 1,
      color: ColorResources.border.withValues(alpha: 0.6),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorResources.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Logout",
          style: cormorantInfantBold.copyWith(
            color: ColorResources.textDark,
            fontSize: 18,
          ),
        ),
        content: Text(
          "Are you sure you want to sign out of your account?",
          style: avenirNextCyr.copyWith(
            color: ColorResources.textLight,
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              "Cancel",
              style: avenirNextCyr.copyWith(
                color: ColorResources.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              "Logout",
              style: avenirNextCyr.copyWith(
                color: ColorResources.primaryRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await SessionPrefs.logout();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthLoginScreen()),
      (route) => false,
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorResources.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Delete Account",
          style: cormorantInfantBold.copyWith(
            color: ColorResources.textDark,
            fontSize: 18,
          ),
        ),
        content: Text(
          "This will permanently delete your account and all associated data. "
          "This action cannot be undone.",
          style: avenirNextCyr.copyWith(
            color: ColorResources.textLight,
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              "Cancel",
              style: avenirNextCyr.copyWith(
                color: ColorResources.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              "Delete",
              style: avenirNextCyr.copyWith(
                color: ColorResources.primaryRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await SessionPrefs.deleteAccount();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthLoginScreen()),
      (route) => false,
    );
  }

  Widget _actionRow({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(icon, width: 20, height: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: avenirNextCyr.copyWith(
                      color: ColorResources.primaryRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: avenirNextCyr.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ColorResources.textLight,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
