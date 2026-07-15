import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matabari/config/utils/apis/api_client.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/payment_details.dart';
import 'package:matabari/widgets/formfield.dart';

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

  File? shopLicense;
  File? fssaiCertificate;
  File? gstCertificate;
  File? aadhaarFile;
  File? panFile;

  bool isSubmitting = false;

  List<Map<String, dynamic>> businessTypes = [];
  bool loadingBusinessTypes = true;

  final List<String> states = [
    "Uttar Pradesh",
    "Delhi",
    "Maharashtra",
    "Rajasthan",
    "Gujarat",
    "Punjab",
    "Haryana",
  ];

  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  void initState() {
    super.initState();
    _fetchBusinessTypes();
  }

  Future<void> _fetchBusinessTypes() async {
    try {
      final response = await ApiClient.getBusinessListing();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = body['data'] as List<dynamic>? ?? [];
        setState(() => businessTypes = data.cast<Map<String, dynamic>>());
        return;
      }
    } catch (_) {
      // Fetch failed - fall through to the empty-state placeholder below
      // rather than blocking the form.
    } finally {
      if (mounted) setState(() => loadingBusinessTypes = false);
    }
  }

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

          case "adhar":
            aadhaarFile = File(image.path);
            break;

          case "pan":
            panFile = File(image.path);
            break;
        }
      });
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> submitForm() async {
    if (shopLicense == null) {
      showMessage("Please upload Shop License");
      return;
    }

    if (fssaiCertificate == null) {
      showMessage("Please upload FSSAI Certificate");
      return;
    }

    if (aadhaarFile == null) {
      showMessage("Please upload Aadhaar Card");
      return;
    }

    if (panFile == null) {
      showMessage("Please upload PAN Card");
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final selectedBusiness = businessTypes.firstWhere(
      (b) => b['name'] == businessType,
      orElse: () => const {},
    );
    final businessId = selectedBusiness['id'] as int?;

    setState(() => isSubmitting = true);
    try {
      final response = await ApiClient.submitSellerBusinessDetails(
        businessId: businessId,
        gstNo: gstController.text.trim(),
        panNo: panController.text.trim(),
        registrationNo: registrationController.text.trim(),
        shopAddressLine1: address1Controller.text.trim(),
        shopAddressLine2: address2Controller.text.trim(),
        state: selectedState ?? '',
        pincode: pinCodeController.text.trim(),
        shopLicenseFile: shopLicense!,
        fssaiCertificateFile: fssaiCertificate!,
        gstFile: gstCertificate,
        adharFile: aadhaarFile!,
        panFile: panFile!,
      );
      if (!mounted) return;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        showMessage(body['message'] as String? ?? "Failed to save business details.");
        return;
      }

      showMessage(body['message'] as String? ?? "Business Details Submitted");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BankPaymentDetailsPage()),
      );
    } catch (_) {
      if (!mounted) return;
      showMessage("Something went wrong. Please check your connection.");
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Widget businessTypeField() {
    if (loadingBusinessTypes) {
      return businessTypePlaceholder("Loading business types...");
    }

    if (businessTypes.isEmpty) {
      return businessTypePlaceholder("No business types available yet");
    }

    return LabeledDropdownField<String>(
      label: "Business Type",
      hint: "e.g. Prasad Seller",
      value: businessType,
      items: businessTypes.map((item) {
        final name = item['name'] as String;
        return DropdownMenuItem(value: name, child: Text(name));
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
    );
  }

  Widget businessTypePlaceholder(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Business Type", style: LabeledTextField.labelStyle),
        const SizedBox(height: 8),
        Container(
          height: 54,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: ColorResources.cardBg,
            border: Border.all(color: ColorResources.border),
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          ),
          child: Text(
            message,
            style: TextStyle(color: ColorResources.textLight, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget uploadField({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: LabeledTextField.labelStyle),
        const SizedBox(height: 8),

        Container(
          height: 54,
          decoration: BoxDecoration(
            color: ColorResources.cardBg,
            border: Border.all(color: ColorResources.border),
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    file == null
                        ? "Click to upload $title"
                        : file.path.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: file == null
                          ? ColorResources.textLight
                          : ColorResources.textDark,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.all(5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _redGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget uploadedPreview(File? file) {
    if (file == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(file, height: 100, width: 100, fit: BoxFit.cover),
      ),
    );
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Heading
                ShaderMask(
                  shaderCallback: (bounds) =>
                      _redGradient.createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    "Enter your\nBusiness Details.",
                    style: avenirNextCyr.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// Business Type
                businessTypeField(),

                const SizedBox(height: 18),

                /// GST & PAN
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        label: "GST Number (Optional)",
                        hint: "GST Number",
                        controller: gstController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LabeledTextField(
                        label: "PAN Number",
                        hint: "PAN Number",
                        controller: panController,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }

                          if (!RegExp(
                            r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                          ).hasMatch(value)) {
                            return "Invalid PAN Number";
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// Registration Number
                LabeledTextField(
                  label: "Business Registration Number",
                  hint: "Enter your BRN",
                  controller: registrationController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter registration number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// Address 1
                LabeledTextField(
                  label: "Shop Address",
                  hint: "Address Line 1",
                  controller: address1Controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter address";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                LabeledTextField(
                  label: "",
                  hint: "Address Line 2",
                  controller: address2Controller,
                ),

                const SizedBox(height: 18),

                /// State & Pincode
                Row(
                  children: [
                    Expanded(
                      child: LabeledDropdownField<String>(
                        label: "State",
                        hint: "Enter State",
                        value: selectedState,
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
                      child: LabeledTextField(
                        label: "PIN Code",
                        hint: "Enter PIN Code",
                        controller: pinCodeController,
                        keyboardType: TextInputType.number,
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

                const SizedBox(height: 18),

                /// Document Uploads
                uploadField(
                  title: "Shop License",
                  file: shopLicense,
                  onTap: () => pickImage("shop"),
                ),
                uploadedPreview(shopLicense),

                const SizedBox(height: 18),

                uploadField(
                  title: "FSSAI Certificate",
                  file: fssaiCertificate,
                  onTap: () => pickImage("fssai"),
                ),
                uploadedPreview(fssaiCertificate),

                const SizedBox(height: 18),

                uploadField(
                  title: "Aadhaar Card",
                  file: aadhaarFile,
                  onTap: () => pickImage("adhar"),
                ),
                uploadedPreview(aadhaarFile),

                const SizedBox(height: 18),

                uploadField(
                  title: "PAN Card",
                  file: panFile,
                  onTap: () => pickImage("pan"),
                ),
                uploadedPreview(panFile),

                const SizedBox(height: 18),

                uploadField(
                  title: "GST Certificate (Optional)",
                  file: gstCertificate,
                  onTap: () => pickImage("gst"),
                ),
                uploadedPreview(gstCertificate),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _redGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isSubmitting ? "Please wait..." : "Next",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
