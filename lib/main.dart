import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matabari/config/utils/app_constants.dart';
import 'package:matabari/ui%20screens/authscreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: AppConstants.appName,

      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFA61D2A),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA61D2A),
          primary: const Color(0xFFA61D2A),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA61D2A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA61D2A),
            foregroundColor: Colors.white,
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}