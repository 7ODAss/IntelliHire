import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/auth_step_layout.dart';
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
    return AuthStepLayout(
      isHeader: true,
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
    );
  }
}
