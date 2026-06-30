import 'package:flutter/material.dart';

class CustomRoleStepper extends StatelessWidget {

  final int currentStep;
  final Function(int) onTap;

  const CustomRoleStepper({
    super.key,
    required this.currentStep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    List<String> roles = [
      "Devotee",
      "Pandit Ji",
      "Prasad Seller"
    ];

    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        children: List.generate(
          roles.length,
              (index) {
            bool selected =
                currentStep == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xffB61C2D)
                        : Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      roles[index],
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}