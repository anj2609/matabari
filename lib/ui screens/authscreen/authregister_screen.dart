import 'dart:convert';
import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/business_details.dart';
import 'package:matabari/ui%20screens/screens/devotee/dashbboard_screen.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/pandit_dashboard_screen.dart';
import 'package:matabari/widgets/formfield.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;

  const RegistrationScreen({super.key, this.phoneNumber = ''});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedRole = "Devotee";
  final List<String> roles = ["Devotee", "Pandit Ji", "Prasad Seller"];

  final TextEditingController dobController = TextEditingController();
  String? selectedGender;
  final List<String> genders = ["Male", "Female", "Other"];

  final ownerFirstNameController = TextEditingController();
  final ownerLastNameController = TextEditingController();
  final sellerMobileController = TextEditingController();
  final sellerEmailController = TextEditingController();
  final sellerShopNameController = TextEditingController();

  final devoteeFirstNameController = TextEditingController();
  final devoteeLastNameController = TextEditingController();
  final devoteeMobileController = TextEditingController();
  final devoteeEmailController = TextEditingController();

  final panditFirstNameController = TextEditingController();
  final panditLastNameController = TextEditingController();
  final panditMobileController = TextEditingController();
  final panditEmailController = TextEditingController();
  final panditSkillController = TextEditingController();

  File? profileImage;
  bool isSubmitting = false;

  // Shared red gradient (same as the onboarding screens).
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  void initState() {
    super.initState();
    // The phone number is already verified via OTP, so every role's form
    // shows it pre-filled and locked rather than letting it be re-typed.
    devoteeMobileController.text = widget.phoneNumber;
    panditMobileController.text = widget.phoneNumber;
    sellerMobileController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    dobController.dispose();
    ownerFirstNameController.dispose();
    ownerLastNameController.dispose();
    sellerMobileController.dispose();
    sellerEmailController.dispose();
    sellerShopNameController.dispose();
    devoteeFirstNameController.dispose();
    devoteeLastNameController.dispose();
    devoteeMobileController.dispose();
    devoteeEmailController.dispose();
    panditFirstNameController.dispose();
    panditLastNameController.dispose();
    panditMobileController.dispose();
    panditEmailController.dispose();
    panditSkillController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => profileImage = File(image.path));
    }
  }

  /// Calls api/basic-info with whichever fields the current role's form
  /// collected, plus the shared profile photo. Returns true on success;
  /// shows an error snackbar and returns false otherwise.
  Future<bool> _submitBasicInfo({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    String? gender,
    String? dob,
    String? skill,
    String? shopName,
  }) async {
    setState(() => isSubmitting = true);
    try {
      final response = await ApiClient.updateBasicInfo(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        gender: gender,
        dob: dob,
        skill: skill,
        shopName: shopName,
        profileImage: profileImage,
      );
      if (!mounted) return false;

      if (response.statusCode == 200) return true;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'] as String? ?? "Failed to save profile.")),
      );
      return false;
    } catch (_) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Please check your connection.")),
      );
      return false;
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8E8D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.hight20,
            vertical: Dimensions.hight20,
          ),
          child: Column(
            children: [
              SizedBox(height: Dimensions.hight20),

              /// Heading
              ShaderMask(
                shaderCallback: (bounds) => _redGradient.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  "Setup your account",
                  style: cormorantInfantBold.copyWith(
                    color: Colors.white,
                    fontSize: 34,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter details to create your account",
                style: avenirNextCyr.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: Dimensions.spacingSize12,
                ),
              ),

              SizedBox(height: Dimensions.spacingSize25),

              profileImagePicker(),

              /// Role Selector
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .50),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .6),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final segmentWidth =
                            constraints.maxWidth / roles.length;
                        final selectedIndex = roles.indexOf(selectedRole);

                        return Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              left: segmentWidth * selectedIndex,
                              top: 0,
                              bottom: 0,
                              width: segmentWidth,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: _redGradient,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            Row(children: roles.map(roleButton).toList()),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: Dimensions.spacingSize30),

              if (selectedRole == "Devotee") devoteeForm(),
              if (selectedRole == "Pandit Ji") panditForm(),
              if (selectedRole == "Prasad Seller") sellerForm(),

              Column(
                children: [
                  SizedBox(height: Dimensions.fontSizeDefault),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: _redGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isSubmitting
                                  ? null
                                  : selectedRole == "Prasad Seller"
                                  ? () async {
                                      final fullName =
                                          "${ownerFirstNameController.text.trim()} ${ownerLastNameController.text.trim()}"
                                              .trim();
                                      final success = await _submitBasicInfo(
                                        firstName: ownerFirstNameController.text.trim(),
                                        lastName: ownerLastNameController.text.trim(),
                                        mobile: sellerMobileController.text.trim(),
                                        email: sellerEmailController.text.trim(),
                                        shopName: sellerShopNameController.text.trim(),
                                      );
                                      if (!success) return;
                                      if (fullName.isNotEmpty) {
                                        await SessionPrefs.setUserName(
                                          fullName,
                                        );
                                      }
                                      if (!context.mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessDetailScreen(),
                                        ),
                                      );
                                    }
                                  : selectedRole == "Devotee"
                                  ? () async {
                                      final fullName =
                                          "${devoteeFirstNameController.text.trim()} ${devoteeLastNameController.text.trim()}"
                                              .trim();
                                      final success = await _submitBasicInfo(
                                        firstName: devoteeFirstNameController.text.trim(),
                                        lastName: devoteeLastNameController.text.trim(),
                                        mobile: devoteeMobileController.text.trim(),
                                        email: devoteeEmailController.text.trim(),
                                      );
                                      if (!success) return;
                                      if (fullName.isNotEmpty) {
                                        await SessionPrefs.setUserName(
                                          fullName,
                                        );
                                      }
                                      await SessionPrefs.setLoggedIn('devotee');
                                      if (!context.mounted) return;
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  : selectedRole == "Pandit Ji"
                                  ? () async {
                                      final fullName =
                                          "${panditFirstNameController.text.trim()} ${panditLastNameController.text.trim()}"
                                              .trim();
                                      final success = await _submitBasicInfo(
                                        firstName: panditFirstNameController.text.trim(),
                                        lastName: panditLastNameController.text.trim(),
                                        mobile: panditMobileController.text.trim(),
                                        email: panditEmailController.text.trim(),
                                        gender: selectedGender,
                                        dob: dobController.text.trim(),
                                        skill: panditSkillController.text.trim(),
                                      );
                                      if (!success) return;
                                      if (fullName.isNotEmpty) {
                                        await SessionPrefs.setUserName(
                                          fullName,
                                        );
                                      }
                                      await SessionPrefs.setLoggedIn('pandit');
                                      if (!context.mounted) return;
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PanditDashboardScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  : null,
                              child: Text(
                                isSubmitting
                                    ? 'Please wait...'
                                    : selectedRole == "Prasad Seller"
                                    ? 'Next'
                                    : 'Sign Up',
                                style: avenirNextCyr.copyWith(
                                  color: ColorResources.whiteColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: avenirNextCyr.copyWith(
                        color: ColorResources.textLight,
                        fontSize: 10,
                      ),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: avenirNextCyr.copyWith(
                            color: ColorResources.primary,
                            fontSize: 10,
                            decoration: TextDecoration.underline,
                            decorationColor: ColorResources.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileImagePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: GestureDetector(
          onTap: _pickProfileImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: ColorResources.cardBg,
                backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                child: profileImage == null
                    ? const Icon(Icons.person, size: 44, color: ColorResources.textLight)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: _redGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roleButton(String title) {
    bool selected = selectedRole == title;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            selectedRole = title;
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            style: avenirNextCyr.copyWith(
              color: selected
                  ? ColorResources.whiteColor
                  : ColorResources.blackColor,
              fontSize: Dimensions.spacingSize12,
            ),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget customField(
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: LabeledTextField(
        label: label,
        hint: hint,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget phoneField(TextEditingController controller) {
    return customField(
      "Mobile Number",
      "Verified mobile number",
      controller: controller,
      keyboardType: TextInputType.phone,
      readOnly: true,
      suffixIcon: const Icon(
        Icons.lock_outline,
        size: 18,
        color: ColorResources.textLight,
      ),
    );
  }

  Widget dobField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: LabeledTextField(
        label: "Date of Birth",
        hint: "DD/MM/YYYY",
        controller: dobController,
        readOnly: true,
        onTap: _pickDateOfBirth,
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: ColorResources.textLight,
          ),
          onPressed: _pickDateOfBirth,
        ),
      ),
    );
  }

  Widget genderField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: LabeledDropdownField<String>(
        label: "Gender",
        hint: "Select gender",
        value: selectedGender,
        items: genders
            .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
      ),
    );
  }

  Widget devoteeForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: customField(
                "First Name",
                "Enter your first name",
                controller: devoteeFirstNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: customField(
                "Last Name",
                "Enter your last name",
                controller: devoteeLastNameController,
              ),
            ),
          ],
        ),
        phoneField(devoteeMobileController),
        customField(
          "Email Address",
          "Enter your email",
          controller: devoteeEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        // button("Sign Up"),
      ],
    );
  }

  Widget panditForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: customField(
                "First Name",
                "Enter your first name",
                controller: panditFirstNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: customField(
                "Last Name",
                "Enter your last name",
                controller: panditLastNameController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: dobField()),
            const SizedBox(width: 12),
            Expanded(child: genderField()),
          ],
        ),
        phoneField(panditMobileController),
        customField(
          "Email Address",
          "Enter your email",
          controller: panditEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        customField(
          "Skills",
          "Enter your skills",
          controller: panditSkillController,
        ),
        // button("Sign Up"),
      ],
    );
  }

  Widget sellerForm() {
    return Column(
      children: [
        customField(
          "Business / Shop Name",
          "Enter your business name",
          controller: sellerShopNameController,
        ),
        Row(
          children: [
            Expanded(
              child: customField(
                "Owner First Name",
                "Enter first name",
                controller: ownerFirstNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: customField(
                "Owner Last Name",
                "Enter last name",
                controller: ownerLastNameController,
              ),
            ),
          ],
        ),
        phoneField(sellerMobileController),
        customField(
          "Email Address",
          "Enter your email",
          controller: sellerEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        //button("Next"),
      ],
    );
  }
}
