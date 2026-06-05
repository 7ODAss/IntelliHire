import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';

import '../../../../../../../../core/utils/app_text_style.dart';

class Footer extends StatelessWidget {
  const Footer({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Text(
          "Already have account? ",
          style: AppTextStyle.textstyle14.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.grey,
          ),
        ),

        GestureDetector(
          onTap: onPressed,

          child:  Text(
            "Log In",

            style: AppTextStyle.textstyle14.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.primary,
          ),
          ),
        ),
      ],
    );
  }
}
