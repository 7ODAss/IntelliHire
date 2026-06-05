import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_text_style.dart';

class MyFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final VoidCallback? onSuffixPressed;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;


  const MyFormField({
    super.key,
    required this.controller,
    required this.type,
    this.suffixIcon,
    this.suffixIconColor,
    this.onSuffixPressed,
    this.obscureText = false,
    this.validator,
    this.hintText,
    this.prefixIcon,
    this.prefixIconColor,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: const Color(0xFFFFFFFF),
        focusColor: const Color(0xFFFFFFFF),
        filled: true,
        hintText: hintText,
        hintStyle: AppTextStyle.hintTextStyle,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xFFD6D6D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFF0F172A), // Dark navy border
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
        suffixIcon: suffixIcon != null ? IconButton(
          onPressed: onSuffixPressed,
          icon: Icon(
           suffixIcon,
            color: suffixIconColor,
          ),
        ) : null,
        prefixIcon: prefixIcon != null ? Icon(
            prefixIcon,
            color: prefixIconColor,
          ) : null,
      ),
    );
  }
}
