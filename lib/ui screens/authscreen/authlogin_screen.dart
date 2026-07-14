import 'package:flutter/material.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/button_screen.dart';
import 'package:matabari/ui%20screens/authscreen/otp_screen.dart';
import 'package:matabari/widgets/formfield.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  bool isAccepted = false;
  bool isSendingOtp = false;
  final TextEditingController mobileController = TextEditingController();

  Future<void> _sendOtp() async {
    if (isSendingOtp) return;
    setState(() => isSendingOtp = true);

    final phone = mobileController.text.trim();
    try {
      final response = await ApiClient.sendOtp(phone);
      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phone)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to send OTP. Please try again."),
            backgroundColor: Color(0xFFB11D2E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please check your connection."),
          backgroundColor: Color(0xFFB11D2E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => isSendingOtp = false);
    }
  }

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
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffC42118),
                      Color(0xff9D1911),
                      Color(0xff650E07),
                    ],
                    stops: [0.0, 0.45, 1.0],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    "Bringing Devotion\nCloser to Every Devotee",
                    textAlign: TextAlign.center,
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Image.asset('assets/images/group.png'),
                const SizedBox(height: 20),
                Text(
                  "Join thousands of devotees connected with",
                  style: avenirNextCyr.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: Dimensions.spacingSize12,
                  ),
                ),
                Center(
                  child: Text(
                    "Matabari Pera digitally.",
                    style: avenirNextCyr.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize12,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// Mobile Field
                LabeledTextField(
                  label: "Mobile Number",
                  hint: "Enter your number",
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("🇮🇳", style: TextStyle(fontSize: 20)),
                        SizedBox(width: Dimensions.smallSpace),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: ColorResources.textDark,
                        ),
                        Container(
                          width: 1,
                          height: 22,
                          margin: const EdgeInsets.only(left: 12),
                          color: ColorResources.border,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// Terms Checkbox
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        value: isAccepted,
                        activeColor: const Color(0xFFB11D2E),
                        shape: const CircleBorder(),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          setState(() {
                            isAccepted = value ?? false;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                          children: [
                            TextSpan(
                              text: "I accept ",
                              style: avenirNextCyr.copyWith(
                                color: ColorResources.textLight,
                                fontSize: Dimensions.spacingSize12,
                              ),
                            ),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: avenirNextCyr.copyWith(
                                color: ColorResources.kArrow,
                                fontSize: Dimensions.spacingSize12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// OTP Button
                CustomButton(
                  title: isSendingOtp ? "Sending..." : "Send OTP",
                  onTap: () {
                    if (!isAccepted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please check the Terms & Conditions box",
                          ),
                          backgroundColor: Color(0xFFB11D2E),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    _sendOtp();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
