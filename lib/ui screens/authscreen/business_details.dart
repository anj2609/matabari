import 'package:flutter/material.dart';
import 'package:matabari/ui%20screens/authscreen/product_info.dart';


class BusinessDetailScreen extends StatefulWidget {
  const BusinessDetailScreen({super.key});

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  String? businessType;
  String? selectedState;

  final gstController = TextEditingController();
  final panController = TextEditingController();
  final registrationController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final pinCodeController = TextEditingController();

  final List<String> businessTypes = [
    "Prasad Seller",
    "Temple Vendor",
    "Flower Seller",
    "Sweet Shop",
  ];

  final List<String> states = [
    "Uttar Pradesh",
    "Delhi",
    "Maharashtra",
    "Rajasthan",
    "Gujarat",
    "Punjab",
    "Haryana",
  ];

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
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
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Business Details Submitted")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductInformation()),
      );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8E8D0),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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

                /// Heading
                const Text(
                  "Enter your\nBusiness Details.",
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffA71D2A),
                  ),
                ),

                const SizedBox(height: 35),

                /// Business Type
                const Text("Business Type", style: TextStyle(fontSize: 12)),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: businessType,
                  decoration: fieldDecoration("e.g. Prasad Seller"),
                  items: businessTypes.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Select business type";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      businessType = value;
                    });
                  },
                ),

                const SizedBox(height: 18),

                /// GST & PAN
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "GST Number (Optional)",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: gstController,
                            decoration: fieldDecoration("GST Number"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PAN Number",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: panController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: fieldDecoration("PAN Number"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }

                              if (value.length != 10) {
                                return "Invalid PAN 10 Numbers";
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// Registration Number
                const Text(
                  "Business Registration Number",
                  style: TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: registrationController,
                  decoration: fieldDecoration("Enter your BRN"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter registration number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// Address 1
                const Text("Shop Address", style: TextStyle(fontSize: 12)),

                const SizedBox(height: 8),

                TextFormField(
                  controller: address1Controller,
                  decoration: fieldDecoration("Address Line 1"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter address";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: address2Controller,
                  decoration: fieldDecoration("Address Line 2"),
                ),

                const SizedBox(height: 18),

                /// State & Pincode
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedState,
                        decoration: fieldDecoration("Enter State"),
                        items: states.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return "Select state";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextFormField(
                        controller: pinCodeController,
                        keyboardType: TextInputType.number,
                        decoration: fieldDecoration("Enter PIN Code"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }

                          if (value.length != 6) {
                            return "Invalid";
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB21E2B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
