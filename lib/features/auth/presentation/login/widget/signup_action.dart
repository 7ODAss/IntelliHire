import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';

class SignupAction extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  const SignupAction({super.key, required this.formKey, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.loginButtonBackgroundColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: () {
        if (formKey.currentState?.validate() == true) {
          // Navigate to next screen or handle login
        }
      },
      child: Text(
        title,
        style: AppTextStyle.loginButtonStyle,
      ),
    );
  }
}
