import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:matabari/ui%20screens/authscreen/business_details.dart';
import 'package:matabari/ui%20screens/authscreen/payment_details.dart';

class ProductInformation extends StatefulWidget {
  const ProductInformation({super.key});

  @override
  State<ProductInformation> createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController descriptionController = TextEditingController();

  String? selectedPrasad;
  File? selectedImage;

  final List<String> prasadList = [
    "Laddu",
    "Peda",
    "Kaju Katli",
    "Barfi",
    "Halwa",
  ];

  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void validateAndProceed() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload product image")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form Submitted Successfully")),
    );
   Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BankPaymentDetailsPage()),
      );
   
  }

  @override
  void dispose() {
    descriptionController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      child: const Text(
                        "Skip",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Heading
                const Text(
                  "Enter your\nProduct Information.",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffA71D2A),
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 35),

                /// Type of Prasad
                const Text(
                  "Types of Prasad",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: selectedPrasad,
                  decoration: InputDecoration(
                    hintText: "e.g : Laddu",
                    filled: true,
                    fillColor: Colors.white.withOpacity(.5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  items: prasadList.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select prasad type";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedPrasad = value;
                    });
                  },
                ),

                const SizedBox(height: 22),

                /// Upload Images
                const Text(
                  "Upload Product Images",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            selectedImage == null
                                ? "Click to upload"
                                : "Image Selected",
                            style: TextStyle(
                              color: selectedImage == null
                                  ? Colors.grey
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xffB21E2B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.upload_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Upload",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                const SizedBox(height: 22),

                /// Description
                const Text(
                  "Product Description",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your product description",
                    filled: true,
                    fillColor: Colors.white.withOpacity(.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter description";
                    }

                    if (value.length < 10) {
                      return "Minimum 10 characters required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: validateAndProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB21E2B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
