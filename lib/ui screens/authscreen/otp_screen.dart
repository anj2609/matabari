import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/authregister_screen.dart';
import 'package:matabari/widgets/button_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, this.phoneNumber = ''});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // Shows the entered number prefixed with +91, or a placeholder if none.
  String _displayNumber() {
    final number = widget.phoneNumber.trim();
    if (number.isEmpty) return "your mobile number";
    return "+91 $number";
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      // Move to the next box once this one is filled.
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move back when the box is cleared.
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
         width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCE7CA),
              Color(0xFFFEF6E9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              children: [
                const Spacer(),

                // Title
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
                    "Enter OTP Code",
                    textAlign: TextAlign.center,
                    style: cormorantInfantBold.copyWith(
                      fontSize: 34,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Check your messages! We've sent a one-time code to\n"
                  "${_displayNumber()}. Enter the code below to verify your\n"
                  "account and continue.",
                  textAlign: TextAlign.center,
                  style: avenirNextCyr.copyWith(
                    fontSize: 12,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _otpLength,
                    (index) => SizedBox(
                      width: 48,
                      height: 58,
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onChanged(value, index),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFC8A97E),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFC8A97E),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFC8A97E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Verify Button
               CustomButton(
                  title: "Verify",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                ),
               
                

                const SizedBox(height: 16),

                // Resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't get a code? ",
                      style: avenirNextCyr.copyWith(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ShaderMask(
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
                          "Click to resend",
                          style: avenirNextCyr.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}