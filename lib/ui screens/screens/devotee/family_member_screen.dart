import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';
import 'package:matabari/widgets/formfield.dart';

class FamilyMemberScreen extends StatefulWidget {
  const FamilyMemberScreen({super.key});

  @override
  State<FamilyMemberScreen> createState() => _FamilyMemberScreenState();
}

class _FamilyMemberScreenState extends State<FamilyMemberScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  final List<Map<String, String>> familyMembers = [
    {
      "name": "Rajesh Sharma",
      "relationTag": "Self",
      "gender": "Male",
      "age": "45 Years",
      "dob": "16 Jan 1980",
      "role": "Family Head",
    },
    {
      "name": "Sunita Sharma",
      "relationTag": "Spouse",
      "gender": "Female",
      "age": "42 Years",
      "dob": "21 Mar 1983",
      "role": "Mother",
    },
    {
      "name": "Aarav Sharma",
      "relationTag": "Son",
      "gender": "Male",
      "age": "18 Years",
      "dob": "17 Aug 2007",
      "role": "Brother",
    },
    {
      "name": "Ananya Sharma",
      "relationTag": "Daughter",
      "gender": "Female",
      "age": "15 Years",
      "dob": "03 Jul 2010",
      "role": "Sister",
    },
  ];

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Group 31.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .2),
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Family Member",
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.spacingSize22,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Manage your family for puja & offerings",
                                  textAlign: TextAlign.center,
                                  style: avenirNextRegular.copyWith(
                                    color: Colors.white70,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 34),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// BODY
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffF8F5F0),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(),
                        const SizedBox(height: 10),
                        ...familyMembers.asMap().entries.map(
                          (e) => _familyCard(e.value, e.key),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _gradientText(
            "Your Family Member",
            cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _openMemberForm(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add More",
                  style: avenirNextCyr.copyWith(
                    color: const Color(0xFFE07A00),
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const Icon(Icons.add, size: 16, color: Color(0xFFE07A00)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- FAMILY CARD ----------------
  Widget _familyCard(Map<String, String> member, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffF3D8B3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: ColorResources.kOrange.withValues(alpha: .16),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xffF3D8B3)),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: ColorResources.kOrange,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              member['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: cormorantInfantBold.copyWith(
                                color: ColorResources.blackColor,
                                fontSize: Dimensions.spacingSize16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE07A00),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              member['relationTag']!,
                              style: cormorantInfantBold.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            member['gender'] == 'Male' ? Icons.male : Icons.female,
                            size: 12,
                            color: const Color(0xffF59E0B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${member['gender']} • ${member['age']}",
                            style: avenirNextRegular.copyWith(
                              color: ColorResources.textLight,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.cake_outlined, size: 12, color: Color(0xffF59E0B)),
                          const SizedBox(width: 4),
                          Text(
                            member['dob']!,
                            style: avenirNextRegular.copyWith(
                              color: ColorResources.textLight,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member['role']!,
                        style: avenirNextRegular.copyWith(
                          color: const Color(0xff9D1911),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: () => _openMemberForm(existing: member, index: index),
              child: Container(
                height: 26,
                width: 26,
                decoration: const BoxDecoration(gradient: _redGradient, shape: BoxShape.circle),
                child: const Icon(Icons.edit, color: Colors.white, size: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- ADD / EDIT FORM ----------------
  Future<void> _openMemberForm({Map<String, String>? existing, int? index}) async {
    final nameController = TextEditingController(text: existing?['name'] ?? '');
    final relationController = TextEditingController(text: existing?['relationTag'] ?? '');
    final ageController = TextEditingController(text: existing?['age']?.replaceAll(' Years', '') ?? '');
    final dobController = TextEditingController(text: existing?['dob'] ?? '');
    final roleController = TextEditingController(text: existing?['role'] ?? '');
    String gender = existing?['gender'] ?? 'Male';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffF8F5F0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 18,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 18,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? "Add Family Member" : "Edit Family Member",
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.spacingSize18,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LabeledTextField(label: "Name", hint: "Enter full name", controller: nameController),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      label: "Relation",
                      hint: "e.g. Spouse, Son, Daughter",
                      controller: relationController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => gender = 'Male'),
                            child: _genderChip('Male', gender == 'Male'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => gender = 'Female'),
                            child: _genderChip('Female', gender == 'Female'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: "Age",
                            hint: "Years",
                            controller: ageController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LabeledTextField(
                            label: "Date of Birth",
                            hint: "DD MMM YYYY",
                            controller: dobController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      label: "Role in Family",
                      hint: "e.g. Mother, Brother",
                      controller: roleController,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        if (existing != null) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => familyMembers.removeAt(index!));
                                Navigator.pop(sheetContext);
                              },
                              child: Container(
                                height: 46,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.redAccent),
                                ),
                                child: Text(
                                  "Remove",
                                  style: cormorantInfantBold.copyWith(
                                    color: Colors.redAccent,
                                    fontSize: Dimensions.spacingSize16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          flex: existing != null ? 1 : 2,
                          child: GestureDetector(
                            onTap: () {
                              if (nameController.text.trim().isEmpty) return;
                              final newMember = {
                                "name": nameController.text.trim(),
                                "relationTag": relationController.text.trim().isEmpty
                                    ? "Family"
                                    : relationController.text.trim(),
                                "gender": gender,
                                "age": "${ageController.text.trim()} Years",
                                "dob": dobController.text.trim(),
                                "role": roleController.text.trim(),
                              };
                              setState(() {
                                if (existing != null && index != null) {
                                  familyMembers[index] = newMember;
                                } else {
                                  familyMembers.add(newMember);
                                }
                              });
                              Navigator.pop(sheetContext);
                            },
                            child: Container(
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: _redGradient,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                existing == null ? "Add Member" : "Save Changes",
                                style: cormorantInfantBold.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.spacingSize16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _genderChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: selected ? _redGradient : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
        ),
      ),
      child: Text(
        label,
        style: cormorantInfantBold.copyWith(
          color: selected ? Colors.white : ColorResources.blackColor,
          fontSize: Dimensions.fontSizeDefault,
        ),
      ),
    );
  }
}
