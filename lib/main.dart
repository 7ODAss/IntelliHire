import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_information_company.dart';
import 'features/auth/presentation/login/login_screen.dart';
import 'features/auth/presentation/signup/company/sign_up_company.dart';
import 'features/auth/presentation/signup/company/sign_up_location_company.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpLocationCompany(selectedPage: 1),
    );
  }
}
