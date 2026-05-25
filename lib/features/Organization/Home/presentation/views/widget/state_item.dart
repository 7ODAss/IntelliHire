import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class StateItem extends StatelessWidget {
  const StateItem({
    super.key,
    required this.iconPath,
    required this.count,
    required this.label,
  });
  final String iconPath;
  final String count;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(iconPath, height: 30, width: 30),
        const SizedBox(height: 5),
        Text(
          count,
          style: AppTextStyle.textstyle20.copyWith(
            color: AppColor.darkBlue,
            fontFamily: AppFont.interBold,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTextStyle.textstyle12.copyWith(
            fontSize: 10,
            color: Color(0XFF475569),
          ),
        ),
      ],
    );
  }
}
