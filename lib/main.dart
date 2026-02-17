import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_company.dart';
import 'package:intelli_hire/features/splash/presentation/view/splash_view.dart';

import 'features/auth/presentation/signup/Candidate Signup/views/candidate_signup_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpCompany(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color(0xffF8FAFC),
      ),
    );
  }
}
