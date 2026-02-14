import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';

import '../../../../../../../../core/utils/app_text_style.dart';

class SignupBackButton extends StatelessWidget {
  const SignupBackButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 55),
      child: Row(
        children: [
          IconButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),

          const SizedBox(width: 4),
          Text(
            'Sign up',
            style: AppTextStyle.textstyle14.copyWith(
              fontFamily: AppFont.poppinsRegular,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
