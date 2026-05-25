import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.currentIndex,
    required this.total,
  });
  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    int currentNum = currentIndex + 1;
    int remaining = total - currentNum;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: currentNum,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (remaining > 0)
              Expanded(
                flex: remaining,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Color(0XFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Candidate $currentNum of $total',
              style: AppTextStyle.textstyle12.copyWith(
                color: Color(0XFF475569),
              ),
            ),
            Text(
              '$remaining Remaining',
              style: AppTextStyle.textstyle12.copyWith(
                color: Color(0XFF475569),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
