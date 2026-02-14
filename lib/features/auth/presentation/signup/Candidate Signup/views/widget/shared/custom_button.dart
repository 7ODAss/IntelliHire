import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.onPressed,
    super.key,
    required this.title,
    this.isDisabled = false,
  });

  final void Function()? onPressed;
  final String title;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Color(0xffafafaf) : AppColor.primary,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        child: Text(
          title,
          style: AppTextStyle.textstyle14.copyWith(color: AppColor.white),
        ),
      ),
    );
  }
}
