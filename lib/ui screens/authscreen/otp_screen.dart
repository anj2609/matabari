import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/authregister_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/dashbboard_screen.dart';
import 'package:matabari/ui%20screens/screens/pandit_ji/pandit_dashboard_screen.dart';
import 'package:matabari/ui%20screens/screens/prasad_seller/seller_dashboard_screen.dart';
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

  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

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

  Future<void> _verify() async {
    if (_isVerifying) return;

    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != _otpLength) {
      setState(() => _errorMessage = "Please enter the complete 6-digit OTP");
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient.verifyOtp(widget.phoneNumber, otp);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = body['data'] as Map<String, dynamic>?;
        final token = data?['token'] as String?;
        final userType = data?['user_type'] as String?;

        if (token != null) await SessionPrefs.setToken(token);
        await SessionPrefs.setLoggedIn(userType ?? 'devotee');
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => switch (userType) {
              'seller' => const SellerDashboardScreen(),
              'pandit' => const PanditDashboardScreen(),
              _ => const DashboardScreen(),
            },
          ),
          (route) => false,
        );
        return;
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data != null && data['is_complete'] == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationScreen(phoneNumber: widget.phoneNumber),
          ),
        );
        return;
      }

      setState(() {
        _errorMessage = body['message'] as String? ?? "OTP verification failed";
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Something went wrong. Please check your connection.";
      });
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient.resendOtp(widget.phoneNumber);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes.first.requestFocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body['message'] as String? ?? "OTP resent successfully."),
            backgroundColor: const Color(0xff9D1911),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() {
          _errorMessage = body['message'] as String? ?? "Failed to resend OTP.";
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Something went wrong. Please check your connection.";
      });
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
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

                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: avenirNextCyr.copyWith(
                      color: Colors.redAccent,
                      fontSize: 11,
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Verify Button
                CustomButton(
                  title: _isVerifying ? "Verifying..." : "Verify",
                  onTap: _verify,
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
                      onTap: _isResending ? null : _resendOtp,
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
                          _isResending ? "Resending..." : "Click to resend",
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