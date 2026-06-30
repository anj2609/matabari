import 'package:flutter/material.dart';
import 'package:matabari/ui%20screens/authscreen/business_details.dart';
import 'package:matabari/ui%20screens/authscreen/business_document.dart';

class BankPaymentDetailsPage extends StatefulWidget {
  const BankPaymentDetailsPage({super.key});

  @override
  State<BankPaymentDetailsPage> createState() => _BankPaymentDetailsPageState();
}

class _BankPaymentDetailsPageState extends State<BankPaymentDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final accountHolderController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final upiController = TextEditingController();

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
      filled: true,
      fillColor: const Color(0xffF7F2EB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xffB21E2B)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bank Details Submitted Successfully")),
      );
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusinessDocumentsScreen()),
    );

      // Get.to(() => NextScreen());
    }
   
  }

  @override
  void dispose() {
    accountHolderController.dispose();
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
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      // decoration: BoxDecoration(
                      //   color: Colors.white54,
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      child: const Text("Skip", style: TextStyle(fontSize: 12)),
                    ),
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
                const Text(
                  "Account Holder Name",
                  style: TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: accountHolderController,
                  decoration: fieldDecoration("Enter your account name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter account holder name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// Bank Name
                const Text("Bank Name", style: TextStyle(fontSize: 12)),

                const SizedBox(height: 8),

                TextFormField(
                  controller: bankNameController,
                  decoration: fieldDecoration("Enter bank name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter bank name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// Account Number
                const Text("Account Number", style: TextStyle(fontSize: 12)),

                const SizedBox(height: 8),

                TextFormField(
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: fieldDecoration("Enter your account number"),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "IFSC Code",
                            style: TextStyle(fontSize: 12),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: ifscController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: fieldDecoration("Enter bank IFSC Code"),
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
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("UPI ID", style: TextStyle(fontSize: 12)),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: upiController,
                            decoration: fieldDecoration("Enter your UPI ID"),
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
                        ],
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
