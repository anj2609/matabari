import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPujaController extends GetxController {
    static AllPujaController get instance => Get.find();

 int selectedCategory = 0;
  final List<Map<String, dynamic>> categories = [
    {
      "icon": Icons.temple_hindu,
      "title": "All Pujas",
    },
    {
      "icon": Icons.wb_sunny_outlined,
      "title": "Popular",
    },
    {
      "icon": Icons.favorite_border,
      "title": "Navratri",
    },
    {
      "icon": Icons.auto_awesome,
      "title": "Grah Shanti",
    },
    {
      "icon": Icons.people_alt_outlined,
      "title": "Family",
    },
  ];

  void changeCategory(int index) {
    selectedCategory = index;
    update(['category']);
  }

  final List<Map<String, dynamic>> pujaList = [
    {
      "image":
          "assets/images/shivji.png",
      "title": "Maa Tripura Sundari Mahapuja",
      "description":
          "Invoke blessings of prosperity, beauty & happiness.",
      "duration": "2 Hours",
      "price": "₹499/-",
    },
    {
      "image":
          "assets/images/shivji.png",
      "title": "Rudrabhishek Puja",
      "description":
          "Remove negativity & bring peace and good health.",
      "duration": "1.5 Hours",
      "price": "₹399/-",
    },
    {
      "image":
          "assets/images/shivji.png",
      "title": "Maa Laxmi Puja",
      "description":
          "Bring wealth, positivity and abundance.",
      "duration": "2 Hours",
      "price": "₹599/-",
    },
  ];
}