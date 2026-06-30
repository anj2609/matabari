import 'package:flutter/material.dart';
import 'package:matabari/ui%20screens/screens/aarti_screen.dart';
import 'package:matabari/ui%20screens/screens/home_screen.dart';
import 'package:matabari/ui%20screens/screens/menu_screen.dart';
import 'package:matabari/ui%20screens/screens/pooja_screen.dart';
import 'package:matabari/ui%20screens/screens/prasad_screen.dart';

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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined),
            label: "Puja",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            label: "Aarti",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Prasad",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }
}
