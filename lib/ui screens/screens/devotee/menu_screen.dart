import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/authlogin_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/about_temple_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/e_darshan_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/family_member_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/help_support_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/my_cart_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/my_puja_bookings_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/recent_activity_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/saved_collection_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/terms_privacy_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  String? userName;

  @override
  void initState() {
    super.initState();
    SessionPrefs.getUserName().then((name) {
      if (mounted) setState(() => userName = name);
    });
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileHeader(),
              const SizedBox(height: 20),

              _sectionCard(
                title: "My Activity",
                rows: [
                  _menuRow(
                    context,
                    icon: Icons.event_note_outlined,
                    title: "My Puja Booking",
                    subtitle: "View your booking status & history",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyPujaBookingsScreen()),
                    ),
                  ),
                  _menuRow(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: "My Cart",
                    subtitle: "Manage your prasad & puja items",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyCartScreen()),
                    ),
                  ),
                  _menuRow(
                    context,
                    icon: Icons.bookmark_border,
                    title: "Saved Collections",
                    subtitle: "View saved puja & vidhi",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SavedCollectionScreen()),
                    ),
                  ),
                  _menuRow(
                    context,
                    icon: Icons.history,
                    title: "Recently Activity",
                    subtitle: "Continue your recently viewed items",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecentActivityScreen()),
                    ),
                  ),
                  _menuRow(
                    context,
                    icon: Icons.people_alt_outlined,
                    title: "Family Member",
                    subtitle: "Manage your family details",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FamilyMemberScreen()),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              _sectionCard(
                title: "Temple & Services",
                rows: [
                  _menuRow(
                    context,
                    icon: Icons.info_outline,
                    title: "About Maa Tripura Sundari",
                    subtitle: "Learn about the temple & its history",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutTempleScreen()),
                    ),
                  ),
                  _menuRow(
                    context,
                    icon: Icons.videocam_outlined,
                    title: "e-Darshan",
                    subtitle: "Experience temple darshan online",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EDarshanScreen()),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              _sectionCard(
                title: "Support & Information",
                rows: [
                  _menuRow(
                    context,
                    icon: Icons.headset_mic_outlined,
                    title: "Help & Support",
                    subtitle: "Get instant support",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                    ),
                  ),
                  _menuRow(
                    context,
                    icon: Icons.description_outlined,
                    title: "Terms & Privacy",
                    subtitle: "Read our terms & privacy policy",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TermsPrivacyScreen()),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              _dangerSection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- PROFILE HEADER ----------------
  Widget _profileHeader() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 84,
                width: 84,
                decoration: BoxDecoration(
                  color: ColorResources.kOrange.withValues(alpha: .16),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffF3D8B3), width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: ColorResources.kOrange,
                  size: 46,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: const BoxDecoration(
                    gradient: _redGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userName?.isNotEmpty == true ? userName! : "Devotee",
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: Dimensions.fontSizeExtraLarge,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.verified, color: Color(0xff9D1911), size: 16),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "+91 98765 43210",
            style: avenirNextRegular.copyWith(
              color: ColorResources.textLight,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
          Text(
            "Member since 22 January 2025",
            style: avenirNextRegular.copyWith(
              color: ColorResources.textLight,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- SECTION CARD ----------------
  Widget _sectionCard({required String title, required List<Widget> rows}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffF3D8B3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientText(
              title,
              cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
            ),
            const SizedBox(height: 4),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _menuRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: isLast ? 0 : 12),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ColorResources.kOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: ColorResources.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  /// ---------------- LOGOUT / DELETE ----------------
  Widget _dangerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFDECEA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3C6C1)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => _confirmLogout(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: cormorantInfantBold.copyWith(
                        color: Colors.redAccent,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Sign out of your account",
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Color(0xFFF3C6C1), height: 1),
            InkWell(
              onTap: () => _confirmDeleteAccount(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      "Delete Account",
                      style: cormorantInfantBold.copyWith(
                        color: Colors.redAccent,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Permanently delete your account",
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
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Logout",
          style: cormorantInfantBold.copyWith(
            color: ColorResources.blackColor,
            fontSize: 18,
          ),
        ),
        content: Text(
          "Are you sure you want to sign out of your account?",
          style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              "Cancel",
              style: avenirNextCyr.copyWith(
                color: ColorResources.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              "Logout",
              style: avenirNextCyr.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

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
        backgroundColor: const Color(0xFFFFFBF2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Delete Account",
          style: cormorantInfantBold.copyWith(
            color: ColorResources.blackColor,
            fontSize: 18,
          ),
        ),
        content: Text(
          "This will permanently delete your account and all associated data. "
          "This action cannot be undone.",
          style: avenirNextRegular.copyWith(color: ColorResources.textLight, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              "Cancel",
              style: avenirNextCyr.copyWith(
                color: ColorResources.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              "Delete",
              style: avenirNextCyr.copyWith(
                color: Colors.redAccent,
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
}
