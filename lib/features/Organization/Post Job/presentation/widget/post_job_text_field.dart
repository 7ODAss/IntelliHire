import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class PostJobTextField extends StatelessWidget {
  const PostJobTextField({super.key, required this.title, required this.hint, this.controller, this.validator});
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
            style: AppTextStyle.textstyle14.copyWith(color: AppColor.darkBlue),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.textstyle14.copyWith(
              color: Color(0xffD6D6D6),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
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
