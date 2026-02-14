import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/signup_back_button.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Image(
          image: AssetImage("assets/image/auth_background.png"),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            SignupBackButton(),
            Text("Welcome to IntelliHire", style: AppStyles.textstyle20),
            const SizedBox(height: 8),
            Text(
              "Step into the future of hiring",
              style: AppStyles.textstyle12,
            ),
          ],
        ),
      ],
    );
  }
}
