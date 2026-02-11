import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';

class NavigatorToAccount extends StatelessWidget {
  final String text;
  final String actionText;
  final void Function()? onTap;
  const NavigatorToAccount({super.key, this.onTap,required this.text,required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: text,
            style: AppTextStyle.signUpConditionStyle,
            children: [
              TextSpan(
                text: actionText,
                style: AppTextStyle.signUpConditionStyle
                    .copyWith(
                  color: AppColor.signUpConditionColor2,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = onTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
