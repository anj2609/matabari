import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/screens/dashbboard_screen.dart';
import 'package:matabari/widgets/button_screen.dart';
import 'package:matabari/ui%20screens/authscreen/otp_screen.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  bool isAccepted = false;
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFEF6E9), Color(0xFFFCE7CA)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),

                /// Title
                Text(
                  "Bringing Devotion\nCloser to Every Devotee",
                  textAlign: TextAlign.center,
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.primary,
                    fontSize: Dimensions.spacingSize30,
                  ),
                ),

                SizedBox(height: 20),

                Image.asset('assets/images/group.png'),
                const SizedBox(height: 20),
                Text(
                  "Join thousands of devotees connected with",
                  style: cormorantInfantBold.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize18,
                  ),
                ),
                Center(
                  child: Text(
                    "Matabari Pera digitally.",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize18,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// Mobile Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mobile Number",
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Mobile Field
                Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFD8B46B)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: Dimensions.smallSpace),

                      const Text("🇮🇳", style: TextStyle(fontSize: 20)),

                       SizedBox(width: Dimensions.smallSpace),

                      const Icon(Icons.keyboard_arrow_down, size: 20),

                      Container(
                        width: 1,
                        height: 25,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        color: Colors.grey.shade300,
                      ),

                      Expanded(
                        child: TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your number",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                 SizedBox(height: Dimensions.spacingSize18),

                /// Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isAccepted,
                      activeColor: const Color(0xFFB11D2E),
                      onChanged: (value) {
                        setState(() {
                          isAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                          children: [
                            TextSpan(
                              text: "I accept ",
                              style: cormorantInfantBold.copyWith(
                                color: ColorResources.textLight,
                                fontSize: Dimensions.spacingSize18,
                              ),
                            ),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: cormorantInfantBold.copyWith(
                                color: ColorResources.kArrow,
                                fontSize: Dimensions.spacingSize18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                 SizedBox(height: Dimensions.spacingSize40),

                /// OTP Button
                CustomButton(
                  title: "Send OTP",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpScreen()),
                    );
                  },
                ),

                 SizedBox(height: Dimensions.hight19),

                // /// Login Link
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                      children: [
                        TextSpan(
                          text: "Already have an account. ",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.textLight,
                            fontSize: Dimensions.spacingSize18,
                          ),
                        ),
                        TextSpan(
                          text: "Log in",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.kArrow,
                            fontSize: Dimensions.spacingSize18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
