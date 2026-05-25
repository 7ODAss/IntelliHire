import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class StautsBox extends StatelessWidget {
  const StautsBox({
    super.key,
    required this.label,
    required this.count,
    required this.iconpath,
  });
  final String label;
  final int count;
  final String iconpath;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(iconpath, height: 20, width: 30),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppFont.interRegular,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color(0XFF475569),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFont.interBold,
                  color: AppColor.darkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
