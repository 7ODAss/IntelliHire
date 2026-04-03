import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';

class NavigatorToAccount extends StatelessWidget {
  final String text;
  final String actionText;
  final String? actionText2;
  final void Function()? onTap;
  final void Function()? onTap2;
  const NavigatorToAccount({super.key, this.onTap,required this.text,required this.actionText, this.actionText2, this.onTap2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: RichText(
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
                  if (actionText2 != null)
                    const TextSpan(text: ' or '),
                    TextSpan(
                      text: actionText2,
                      style: AppTextStyle.signUpConditionStyle
                          .copyWith(
                        color: AppColor.signUpConditionColor2,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onTap2,
                    )

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
