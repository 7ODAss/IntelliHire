import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/auth/presentation/signup/widget/custom_stepper.dart';
import 'package:intelli_hire/features/auth/presentation/signup/widget/pop_action.dart';

class CompanySignupHeader extends StatelessWidget {
  final int screenNumber;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const CompanySignupHeader({
    super.key,
    required this.screenNumber,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.5, 0.5, 1.0],
          colors: [
            Colors.white,
            Colors.white,
            Color(0xFF0F172A),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  PopAction(onPressed: onPressed),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomStepper(screenNumber: screenNumber),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyle.signUpTitleInformationCompanyStyle,
            ),
            Text(
              subtitle,
              style: AppTextStyle.loginSubTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}