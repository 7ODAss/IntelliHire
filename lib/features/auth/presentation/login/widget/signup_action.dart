import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';

class SignupAction extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final void Function()? onPressed;
  const SignupAction({super.key, required this.formKey, required this.title, this.onPressed});

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
      onPressed: onPressed,
      child: Text(
        title,
        style: AppTextStyle.loginButtonStyle,
      ),
    );
  }
}
