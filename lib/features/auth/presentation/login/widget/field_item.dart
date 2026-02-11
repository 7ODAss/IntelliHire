import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/my_form_field.dart';

class FieldItem extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String message;
  final TextInputType type;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final VoidCallback? onSuffixPressed;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? hintText;

  const FieldItem({
    super.key,
    required this.controller,
    required this.title,
    required this.message,
    required this.type,
    this.suffixIcon,
    this.suffixIconColor,
    this.onSuffixPressed,
    this.obscureText = false,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.fieldTitleStyle,
        ),
        SizedBox(height: 8),
        MyFormField(
          controller: controller,
          type: type,
          validator: validator,
          suffixIcon: suffixIcon,
          suffixIconColor: suffixIconColor,
          onSuffixPressed: onSuffixPressed,
          obscureText: obscureText,
          hintText: hintText,

        ),
      ],
    );
  }
}
