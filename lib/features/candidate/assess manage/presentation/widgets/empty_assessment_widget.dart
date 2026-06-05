import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class EmptyAssessmentWidget extends StatelessWidget {
  final String message;

  const EmptyAssessmentWidget({
    super.key,
    this.message = 'No Assessment has been done yet.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(48),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              size: 52,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFont.interRegular,
              fontSize: 15,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
