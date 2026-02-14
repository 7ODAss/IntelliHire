import 'package:flutter/material.dart';
import 'package:intelli_hire/features/onboarding/presentation/onboarding_screen.dart';
import 'features/auth/presentation/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
