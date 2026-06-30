import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matabari/ui%20screens/screens/dashbboard_screen.dart';
import 'package:matabari/widgets/button_screen.dart';

class BusinessDocumentsScreen extends StatefulWidget {
  const BusinessDocumentsScreen({super.key});

  @override
  State<BusinessDocumentsScreen> createState() =>
      _BusinessDocumentsScreenState();
}

class _BusinessDocumentsScreenState extends State<BusinessDocumentsScreen> {
  final _formKey = GlobalKey<FormState>();

  File? shopLicense;
  File? fssaiCertificate;
  File? gstCertificate;
  File? selectedImage;

  final aadhaarController = TextEditingController();
  final panController = TextEditingController();

  Future<void> pickImage(String type) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        switch (type) {
          case "shop":
            shopLicense = File(image.path);
            break;

          case "fssai":
            fssaiCertificate = File(image.path);
            break;

          case "gst":
            gstCertificate = File(image.path);
            break;
        }
      });
    }
  }

  void validateAndContinue() {
    if (shopLicense == null) {
      showMessage("Please upload Shop License");
      return;
    }

    if (fssaiCertificate == null) {
      showMessage("Please upload FSSAI Certificate");
      return;
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Documents Verified Successfully")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget uploadField({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 6),

        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xffF4F1EC),
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    file == null
                        ? "Click to upload $title"
                        : file.path.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: file == null ? Colors.grey : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.all(4),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffB61E2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.upload_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Upload",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4E5CF),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Skip"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Verify your Business\nDocuments",
                    style: TextStyle(
                      fontSize: 36,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffB61E2E),
                    ),
                  ),

                  const SizedBox(height: 35),

                  uploadField(
                    title: "Shop License",
                    file: shopLicense,
                    onTap: () => pickImage("shop"),
                  ),
                  if (shopLicense != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          shopLicense!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  /// shopLicense fssaiCertificate gstCertificate selectedImage
                  const SizedBox(height: 18),

                  uploadField(
                    title: "FSSAI Certificate",
                    file: fssaiCertificate,
                    onTap: () => pickImage("fssai"),
                  ),
                  if (fssaiCertificate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          fssaiCertificate!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),

                  uploadField(
                    title: "GST Certificate (Optional)",
                    file: gstCertificate,
                    onTap: () => pickImage("gst"),
                  ),
                  if (gstCertificate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          gstCertificate!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),

                  const Text("Aadhaar Card Number"),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: aadhaarController,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("Enter Aadhaar number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Aadhaar Number";
                      }

                      if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                        return "Aadhaar must be 12 digits";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text("PAN Card Number"),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: panController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: inputDecoration("Enter PAN card number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter PAN Number";
                      }

                      if (!RegExp(
                        r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                      ).hasMatch(value)) {
                        return "Invalid PAN Number";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 40),
                  CustomButton(title: "Next", onTap: validateAndContinue),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xffF4F1EC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
