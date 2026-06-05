import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class JobDescriptionTextField extends StatelessWidget {
  const JobDescriptionTextField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.validator
  });
  final String title;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: AppTextStyle.textstyle14.copyWith(
              color: AppColor.darkBlue,
              fontWeight: FontWeight.w700,
              fontFamily: AppFont.interBold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: validator,
          maxLines: 4,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.textstyle12.copyWith(
              color: Color(0xffD6D6D6),
            ),
            filled: true,
            fillColor: Color(0XFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xffD6D6D6), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xffD6D6D6), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xffD6D6D6), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
