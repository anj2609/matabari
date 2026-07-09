import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPujaController extends GetxController {
    static AllPujaController get instance => Get.find();

 int selectedCategory = 0;
  final List<Map<String, dynamic>> categories = [
    {
      "icon": "assets/images/Group 32.png",
      "title": "All Pujas",
    },
    {
      "icon": "assets/images/Group 33.png",
      "title": "Popular",
    },
    {
      "icon": "assets/images/Group 34.png",
      "title": "Navratri Special",
    },
    {
      "icon": "assets/images/Group 35.png",
      "title": "Graha Shanti",
    },
    {
      "icon": "assets/images/Group 36 (2).png",
      "title": "Family Puja",
    },
  ];

  void changeCategory(int index) {
    selectedCategory = index;
    update();
  }

  final List<Map<String, dynamic>> pujaList = [
    {
      "image":
          "assets/images/Rectangle 693.png",
      "title": "Maa Tripura Sundari Mahapuja",
      "description":
          "Invoke blessings of prosperity, beauty & happiness.",
      "duration": "2 Hours",
      "price": "₹499/-",
    },
    {
      "image":
          "assets/images/Rectangle 703.png",
      "title": "Rudrabhishek Puja",
      "description":
          "Remove negativity & bring peace and good health.",
      "duration": "1.5 Hours",
      "price": "₹399/-",
    },
    {
      "image":
          "assets/images/Rectangle 708.png",
      "title": "Maa Laxmi Puja",
      "description":
          "Bring wealth, positivity and abundance.",
      "duration": "2 Hours",
      "price": "₹599/-",
    },
    {
      "image":
          "assets/images/Rectangle 715.png",
      "title": "Maha Mrityunjay Jaap",
      "description":
          "Overcome fear & obstacles with divine protection.",
      "duration": "1 Hour",
      "price": "₹349/-",
    },
    {
      "image":
          "assets/images/Rectangle 720.png",
      "title": "Navgraha Shanti Puja",
      "description":
          "Balance planetary influences for a smoother life.",
      "duration": "2.5 Hours",
      "price": "₹699/-",
    },
    {
      "image":
          "assets/images/Rectangle 725.png",
      "title": "Kul Devi Puja",
      "description":
          "Seek blessings of the family deity for harmony.",
      "duration": "1.5 Hours",
      "price": "₹449/-",
    },
  ];
}