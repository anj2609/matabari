import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';

/// Seller profile, business/bank details and shop settings shown under
/// the seller dashboard's "My Profile" tab.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _businessDetails = [
    ("Business Name", "Tripura Maa Prasad Bhandar"),
    ("Shop Category", "Prasad & Puja Items"),
    ("Temple Association", "Maa Tripura Sundari Seva Samiti"),
    ("Shop Address", "Varanasi, Uttar Pradesh - 221001"),
  ];

  static const _documents = [
    ("Aadhar Card", 'assets/images/Ellipse 88.png'),
    ("PAN Card", 'assets/images/Ellipse 89.png'),
    ("Certification", 'assets/images/Ellipse 90.png'),
    ("Temple ID", 'assets/images/Ellipse 91.png'),
  ];

  static const _gstDetails = [
    ("GST Number", "22ABCDE1234F1Z5"),
    ("Business Type", "Proprietorship"),
  ];

  static const _settingsItems = [
    "Manage Shop Information",
    "Manage Address",
    "Change Password",
    "Notification Preferences",
  ];

  static TextStyle get _sectionTitleStyle => cormorantInfantBold.copyWith(
    color: ColorResources.textDark,
    fontSize: 14,
  );

  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileCard(),
          const SizedBox(height: 22),
          Text("Business Details", style: _sectionTitleStyle),
          const SizedBox(height: 10),
          _detailsCard(_businessDetails),
          const SizedBox(height: 22),
          Text("Documents", style: _sectionTitleStyle),
          const SizedBox(height: 10),
          _documentsCard(),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("Bank Details", "Edit"),
          const SizedBox(height: 10),
          _bankCard(),
          const SizedBox(height: 22),
          Text("GST Details (Optional)", style: _sectionTitleStyle),
          const SizedBox(height: 10),
          _detailsCard(_gstDetails),
          const SizedBox(height: 22),
          Text("Shop Settings", style: _sectionTitleStyle),
          const SizedBox(height: 10),
          _settingsCard(),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A0F0F), Color(0xFF1C0705)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorResources.kGold, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile icon kept exactly as before.
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorResources.kOrange.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: ColorResources.kOrange,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Member Since: Jan 2024",
                      style: avenirNextCyr.copyWith(
                        color: ColorResources.kGold,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Rakesh Sharma",
                            overflow: TextOverflow.ellipsis,
                            style: cormorantInfantBold.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF6EC1FF),
                          size: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _ratingBadge(),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _glassInfoBadge(Icons.call_rounded, "+91 987-654-3210"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _glassInfoBadge(
                  Icons.mail_rounded,
                  "panditrajesh@gmail.com",
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: _redGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Edit Profile",
                      style: avenirNextCyr.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: ColorResources.kOrange,
            size: 13,
          ),
          const SizedBox(width: 3),
          Text(
            "4.8",
            style: avenirNextCyr.copyWith(
              color: ColorResources.textDark,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6D1F1F), Color(0xFF4A1414)],
        ),
        border: Border.all(color: ColorResources.kGold, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorResources.kGold, size: 13),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: avenirNextCyr.copyWith(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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

  Widget _documentsCard() {
    return _cardDecoration(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Row(
        children: [
          for (final doc in _documents) Expanded(child: _documentItem(doc)),
        ],
      ),
    );
  }

  Widget _documentItem((String, String) doc) {
    final (label, icon) = doc;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, width: 40, height: 40),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: avenirNextCyr.copyWith(
            color: ColorResources.textDark,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          "Verified",
          style: avenirNextCyr.copyWith(
            color: const Color(0xFF4B703C),
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _bankCard() {
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
                "State Bank of India",
                style: avenirNextCyr.copyWith(
                  color: ColorResources.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bankInfoRow("Name: Rajesh Sharma", "A/C No: 1234 5678 9012"),
          const SizedBox(height: 8),
          _bankInfoRow("Account Type: Current", "IFSC: SBIN0001234"),
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

  Widget _settingsCard() {
    return _cardDecoration(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: Column(
        children: [
          for (var i = 0; i < _settingsItems.length; i++) ...[
            if (i != 0) _thinHorizontalDivider(),
            _settingsRow(_settingsItems[i]),
          ],
        ],
      ),
    );
  }

  Widget _settingsRow(String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: avenirNextCyr.copyWith(
                color: ColorResources.textDark,
                fontSize: 11,
                fontWeight: FontWeight.w600,
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

  Widget _thinHorizontalDivider() {
    return Container(
      height: 1,
      color: ColorResources.border.withValues(alpha: 0.6),
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
            onTap: () {},
          ),
        ],
      ),
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
