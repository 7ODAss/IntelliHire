import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        MyFormField(
          controller: controller,
          type: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return message;
            }
            return null;
          },
          suffixIcon: suffixIcon,
          suffixIconColor: suffixIconColor,
          onSuffixPressed: onSuffixPressed,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
