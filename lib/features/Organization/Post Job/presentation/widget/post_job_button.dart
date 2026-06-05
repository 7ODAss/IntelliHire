import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class PostJobButton extends StatelessWidget {
  const PostJobButton({
    super.key,
    required this.flex,
    required this.onPressed,
    required this.text,
    required this.textColor,
    required this.bgColor,
    this.borderColor,
  });
  final int flex;
  final void Function() onPressed;
  final String text;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: borderColor ?? bgColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.interBold,
          ),
        ),
      ),
    );
  }
}
