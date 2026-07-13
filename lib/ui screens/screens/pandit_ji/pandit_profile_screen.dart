import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';

/// "My Profile" tab of the Pandit dashboard - about, specialization,
/// language, availability, documents and bank details.
class PanditProfileScreen extends StatelessWidget {
  const PanditProfileScreen({super.key});

  static const _specializations = [
    "Mata Tripura Sundari Puja",
    "Rudrabhishek",
    "Navagraha Shanti",
    "Durga Saptashati Puja",
    "Grah Shanti Puja",
    "Satyanarayan Katha",
  ];

  static const _languages = ["Hindi", "English", "Sanskrit", "Bhojpuri"];

  static const _availability = [
    ("Available Days", "Monday to Sunday"),
    ("Available Time", "06:00 AM - 10:00 PM"),
    ("Time Zone", "IST (GMT+05:30)"),
  ];

  static const _documents = [
    ("Aadhar Card", 'assets/images/Ellipse 88.png'),
    ("PAN Card", 'assets/images/Ellipse 89.png'),
    ("Certification", 'assets/images/Ellipse 90.png'),
    ("Temple ID", 'assets/images/Ellipse 91.png'),
  ];

  static TextStyle get _sectionTitleStyle => cormorantInfantBold.copyWith(
    color: ColorResources.textDark,
    fontSize: 14,
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
          _sectionHeaderWithAction("About me", "Edit"),
          const SizedBox(height: 10),
          _aboutCard(),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("Specialization", "Edit"),
          const SizedBox(height: 10),
          _chipsCard(_specializations),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("Language", "Edit"),
          const SizedBox(height: 10),
          _chipsCard(_languages),
          const SizedBox(height: 22),
          _sectionHeaderWithAction("Availability", "Edit"),
          const SizedBox(height: 10),
          _detailsCard(_availability),
          const SizedBox(height: 22),
          Text("Documents", style: _sectionTitleStyle),
          const SizedBox(height: 10),
          _documentsCard(),
          const SizedBox(height: 22),
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
                  "Pandit Rajesh Sharma",
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
                "+91 987-654-3210",
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
                  "panditrajesh@gmail.com",
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
          _bankInfoRow("IFSC: SBIN0001234", ""),
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
