import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/candidate_signup_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CandidateSignUp(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color(0xffF8FAFC),
      ),
    );
  }
}
