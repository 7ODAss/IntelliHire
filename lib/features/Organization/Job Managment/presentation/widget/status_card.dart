import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key, required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xff475569),
              fontWeight: FontWeight.w400,
              fontFamily: AppFont.interRegular,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.darkBlue,
              fontFamily: AppFont.interBold,
            ),
          ),
        ],
      ),
    );
  }
}
