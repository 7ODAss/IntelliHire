import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class PointText extends StatelessWidget {
  const PointText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.textstyle12.copyWith(color: Color(0xff475569))
    );
  }
}
