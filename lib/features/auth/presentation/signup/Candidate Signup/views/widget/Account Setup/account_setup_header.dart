import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_stepper.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/signup_back_button.dart';

class AccountSetupHeader extends StatelessWidget {
  const AccountSetupHeader({
    super.key,
    required this.screenNumber,
    required this.title, required this.onPressed,
  });
  final int screenNumber;
  final String title;
    final void Function() onPressed;

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
            SignupBackButton(onPressed: onPressed,),
            const SizedBox(height: 8),

            CustomStepper(screenNumber: screenNumber),
            const SizedBox(height: 16),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: AppFont.inter,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
