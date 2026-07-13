import 'package:flutter/material.dart';
import 'package:matabari/config/utils/session_prefs.dart';
import 'package:matabari/ui%20screens/screens/prasad_seller/seller_dashboard_screen.dart';
import 'package:matabari/widgets/formfield.dart';
import 'package:matabari/widgets/skip_button.dart';

class BankPaymentDetailsPage extends StatefulWidget {
  const BankPaymentDetailsPage({super.key});

  @override
  State<BankPaymentDetailsPage> createState() => _BankPaymentDetailsPageState();
}

class _BankPaymentDetailsPageState extends State<BankPaymentDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final accountHolderFirstController = TextEditingController();
  final accountHolderLastController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final upiController = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bank Details Submitted Successfully")),
      );
      await SessionPrefs.setLoggedIn('seller');
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SellerDashboardScreen()),
        (route) => false,
      );
    }
  }

  void skipToDashboard() async {
    await SessionPrefs.setLoggedIn('seller');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SellerDashboardScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    accountHolderFirstController.dispose();
    accountHolderLastController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8E8D0),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    SkipButton(onTap: skipToDashboard),
                  ],
                ),

                const SizedBox(height: 20),

                /// Title
                const Text(
                  "Enter your Bank\n& Payment Details",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Color(0xffA71D2A),
                  ),
                ),

                const SizedBox(height: 35),

                /// Account Holder Name
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        label: "Account Holder First Name",
                        hint: "Enter first name",
                        controller: accountHolderFirstController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LabeledTextField(
                        label: "Account Holder Last Name",
                        hint: "Enter last name",
                        controller: accountHolderLastController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// Bank Name
                LabeledTextField(
                  label: "Bank Name",
                  hint: "Enter bank name",
                  controller: bankNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter bank name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// Account Number
                LabeledTextField(
                  label: "Account Number",
                  hint: "Enter your account number",
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter account number";
                    }

                    if (value.length < 9) {
                      return "Invalid account number";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// IFSC + UPI
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        label: "IFSC Code",
                        hint: "Enter bank IFSC Code",
                        controller: ifscController,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }

                          if (value.length < 11) {
                            return "Invalid";
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: LabeledTextField(
                        label: "UPI ID",
                        hint: "Enter your UPI ID",
                        controller: upiController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }

                          if (!value.contains("@")) {
                            return "Invalid UPI";
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// Next Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB21E2B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
