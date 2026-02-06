import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/widget/signup_back_button.dart';

class CandidateSignUp extends StatelessWidget {
  const CandidateSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                const Image(
                  image: AssetImage("assets/image/auth_background.png"),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    SignupBackButton(),
                    Text(
                      "Welcome to IntelliHire",
                      style: TextStyle(
                        color: Color(0xffF2F2F2),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFont.poppins,
                      ),
                    ),
                    Text(
                      "Step into the future of hiring",
                      style: TextStyle(
                        color: Color(0xff9CA3AF),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFont.inter,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

