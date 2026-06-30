import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/ui%20screens/authscreen/business_details.dart';
// ignore: unused_import
import 'package:matabari/ui%20screens/authscreen/product_info.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedRole = "Devotee";
  final List<String> roles = ["Devotee", "Pandit Ji", "Prasad Seller"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8E8D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal:  Dimensions.hight20, vertical:  Dimensions.hight20),
          child: Column(
            children: [
               SizedBox(height: Dimensions.hight20),

              /// Heading
              Text(
                "Setup your account",
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.kArrow,
                  fontSize: Dimensions.spacingSize45,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter details to create your account",
                style: cormorantInfantBold.copyWith(
                  color: ColorResources.blackColor,
                  fontSize: Dimensions.spacingSize18,
                ),
              ),

              SizedBox(height: Dimensions.spacingSize25),

              /// Role Selector
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: Row(
                  children: [
                    roleButton("Devotee"),
                    roleButton("Pandit Ji"),
                    roleButton("Prasad Seller"),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.spacingSize30),

              if (selectedRole == "Devotee") devoteeForm(),
              if (selectedRole == "Pandit Ji") panditForm(),
              if (selectedRole == "Prasad Seller") sellerForm(),

              Column(
                children: [
                   SizedBox(height: Dimensions.fontSizeDefault),
                  Row(
                    children: [
                      if (selectedRole != "Devotee") ...[
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffB71C2B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                int currentIndex = roles.indexOf(selectedRole);

                                if (currentIndex > 0) {
                                  setState(() {
                                    selectedRole = roles[currentIndex - 1];
                                  });
                                }
                              },
                              child: Text(
                                "Previous",
                                style: cormorantInfantBold.copyWith(
                                  color: ColorResources.whiteColor,
                                  fontSize: Dimensions.spacingSize20,
                                ),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(width: Dimensions.fontSizeDefault),
                      ],

                      Expanded(
                        flex: selectedRole == "Devotee" ? 2 : 1,
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffB71C2B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              int currentIndex = roles.indexOf(selectedRole);

                              if (currentIndex < roles.length - 1) {
                                setState(() {
                                  selectedRole = roles[currentIndex + 1];
                                });
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BusinessDetailScreen(),
                                  ),
                                );
                                print("Submit");
                              }
                            },
                            child: Text(
                              selectedRole == "Prasad Seller"
                                  ? 'Submit'
                                  : 'Next',
                              style: cormorantInfantBold.copyWith(
                                color: ColorResources.whiteColor,
                                fontSize: Dimensions.spacingSize20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.spacingSize20,
                      ),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: cormorantInfantBold.copyWith(
                            color: ColorResources.primary,
                            fontSize: Dimensions.spacingSize20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roleButton(String title) {
    bool selected = selectedRole == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xffB71C2B) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: cormorantInfantBold.copyWith(
              color: selected ? ColorResources.whiteColor : ColorResources.blackColor,
              fontSize: Dimensions.spacingSize20,
            ),
          
          ),
        ),
      ),
    );
  }

  Widget customField(
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          hintStyle: cormorantInfantBold.copyWith(
                  color: ColorResources.textLight,
                  fontSize: Dimensions.spacingSize18,
                ),
          fillColor: Colors.white.withOpacity(.55),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget devoteeForm() {
    return Column(
      children: [
        customField("Enter your name"),
        customField("+91 987-654-3210", keyboardType: TextInputType.phone),
        customField(
          "Enter your email",
          keyboardType: TextInputType.emailAddress,
        ),
        // button("Sign Up"),
      ],
    );
  }

  Widget panditForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: customField("First Name")),
            const SizedBox(width: 12),
            Expanded(child: customField("Last Name")),
          ],
        ),
        Row(
          children: [
            Expanded(child: customField("DD/MM/YYYY")),
            const SizedBox(width: 12),
            Expanded(child: customField("Gender")),
          ],
        ),
        customField("+91 742-806-9557"),
        customField("Enter your email"),
        customField("Enter your skills"),
        // button("Sign Up"),
      ],
    );
  }

  Widget sellerForm() {
    return Column(
      children: [
        customField("Business / Shop Name"),
        customField("Owner Name"),
        customField("+91 742-806-9557"),
        customField("Enter your email"),
        //button("Next"),
      ],
    );
  }
}
