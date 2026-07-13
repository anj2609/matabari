import 'package:flutter/material.dart';
import 'package:matabari/ui%20screens/screens/devotee/aarti_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/home_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/menu_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/pooja_screen.dart';
import 'package:matabari/ui%20screens/screens/devotee/prasad_screen.dart';
import 'package:matabari/widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    PujaScreen(),
    AartiScreen(),
    PrasadScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
