import 'package:flutter/material.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/custom_bottom_nav_bar_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CustomBottomNavBarWrapper(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xffF8FAFC),
      ),
    );
  }
}
