import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({super.key, required this.icon, required this.label});
  final String icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Color(0xff475569), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(Color(0xff475569), BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyle.textstyle12.copyWith(color: Color(0xff475569)),
          ),
        ],
      ),
    );
  }
}
