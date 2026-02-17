import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';


class SignupBackButton extends StatelessWidget {
  const SignupBackButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2F466C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF2F466C)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2F466C),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Color(0xFF0F172A),
              radius: 18,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onPressed ?? () => Navigator.pop(context),
                ),
              ),
            ),
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
