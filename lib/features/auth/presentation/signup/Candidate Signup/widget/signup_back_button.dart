import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';

class SignupBackButton extends StatelessWidget {
  const SignupBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, top: 55),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),

          const SizedBox(width: 4),
          Text(
            'Sign up',
            style: AppStyles.textstyle14.copyWith(
              fontFamily: AppFont.poppins,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
