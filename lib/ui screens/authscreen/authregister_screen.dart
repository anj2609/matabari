import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/business_details.dart';
import 'package:matabari/widgets/formfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

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

  // Shared red gradient (same as the onboarding screens).
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  void dispose() {
    dobController.dispose();
    ownerFirstNameController.dispose();
    ownerLastNameController.dispose();
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
                              onPressed: selectedRole == "Prasad Seller"
                                  ? () async {
                                      final fullName =
                                          "${ownerFirstNameController.text.trim()} ${ownerLastNameController.text.trim()}"
                                              .trim();
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
                                  : null,
                              child: Text(
                                selectedRole == "Prasad Seller"
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: LabeledTextField(
        label: label,
        hint: hint,
        keyboardType: keyboardType,
        controller: controller,
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
            Expanded(child: customField("First Name", "Enter your first name")),
            const SizedBox(width: 12),
            Expanded(child: customField("Last Name", "Enter your last name")),
          ],
        ),
        customField(
          "Mobile Number",
          "+91 987-654-3210",
          keyboardType: TextInputType.phone,
        ),
        customField(
          "Email Address",
          "Enter your email",
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
            Expanded(child: customField("First Name", "Enter your first name")),
            const SizedBox(width: 12),
            Expanded(child: customField("Last Name", "Enter your last name")),
          ],
        ),
        Row(
          children: [
            Expanded(child: dobField()),
            const SizedBox(width: 12),
            Expanded(child: genderField()),
          ],
        ),
        customField(
          "Mobile Number",
          "+91 742-806-9557",
          keyboardType: TextInputType.phone,
        ),
        customField(
          "Email Address",
          "Enter your email",
          keyboardType: TextInputType.emailAddress,
        ),
        customField("Skills", "Enter your skills"),
        // button("Sign Up"),
      ],
    );
  }

  Widget sellerForm() {
    return Column(
      children: [
        customField("Business / Shop Name", "Enter your business name"),
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
        customField(
          "Mobile Number",
          "+91 742-806-9557",
          keyboardType: TextInputType.phone,
        ),
        customField(
          "Email Address",
          "Enter your email",
          keyboardType: TextInputType.emailAddress,
        ),
        //button("Next"),
      ],
    );
  }
}
